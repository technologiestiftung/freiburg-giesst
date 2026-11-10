#!/bin/sh
# Writes /env.js with the VITE_* values from the container env.
# The image is built with `vite build --mode docker`, so the bundle reads
# window.__ENV__.VITE_X instead of baked-in values (see vite.config.ts).
# Run automatically by the nginx entrypoint (/docker-entrypoint.d).
set -eu

OUT=${RUNTIME_ENV_OUT:-/usr/share/nginx/html/env.js}

# Every VITE_* used in src/. Add "optional" after a name if it may be empty.
VARS="
VITE_SUPABASE_URL
VITE_SUPABASE_ANON_KEY
VITE_MAPBOX_API_KEY
VITE_MAPBOX_API_ENDPOINT
VITE_MAPBOX_STYLE_URL
VITE_MAPBOX_TREES_TILESET_URL
VITE_MAPBOX_TREES_TILESET_LAYER
VITE_BEZIRKE_URL
VITE_RECOVERY_AUTH_REDIRECT_URL
VITE_MAP_CENTER_LAT
VITE_MAP_CENTER_LNG
VITE_MAP_BOUNDING_BOX
VITE_MAP_INITIAL_ZOOM_LEVEL
VITE_MAP_LOCATION_ZOOM_LEVEL
VITE_MAP_MIN_ZOOM_LEVEL
VITE_MAP_MAX_ZOOM_LEVEL
VITE_MAP_PITCH_DEGREES
VITE_MAP_PUMPS_SOURCE_URL optional
VITE_IS_TEMPORARY_BANNER_VISIBLE optional
"

missing=""
json=""
while read -r name flag; do
	[ -n "$name" ] || continue
	eval "val=\${$name:-}"
	if [ -z "$val" ] && [ "$flag" != "optional" ]; then
		missing="$missing $name"
	fi
	esc=$(printf '%s' "$val" | sed 's/\\/\\\\/g; s/"/\\"/g; s/</\\u003c/g')
	json="$json\"$name\":\"$esc\","
done <<EOV
$VARS
EOV

if [ -n "$missing" ]; then
	echo "40-env.sh: missing required env:$missing" >&2
	exit 1
fi

printf 'window.__ENV__={%s};\n' "${json%,}" >"$OUT"
echo "40-env.sh: wrote $OUT"
