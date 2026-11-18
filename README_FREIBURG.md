# Freiburg gießt – Differences from Berlin

This file complements [README_DEV.md](README_DEV.md). `README_DEV.md` is kept identical to upstream to avoid merge conflicts. This file only lists what works differently in Freiburg.

## Pumps

Freiburg has no pumps harvester and no `pumps.yml` workflow.

- Instead of "Upload the Pumps file" in Step 3: upload a static `pumps.geojson` to the `data_assets` bucket by hand (for now an empty `{"type":"FeatureCollection","features":[]}`).
- The file must exist: the `gdk_stats` edge function (`PUMPS_URL`) and the map layer (`VITE_MAP_PUMPS_SOURCE_URL`) both load it.
- If a pumps list becomes available, convert it to GeoJSON with the OSM properties `id`, `pump:status`, `addr:full` and `check_date`, and replace the file.

## Cron job for the tileset

Instead of Pipedream ("Schedule CRON jobs" in Step 3):

- Run a cron job every day at 01:00 AM that starts `.github/workflows/rain.yml` via the GitHub API:
  `POST /repos/technologiestiftung/freiburg-giesst/actions/workflows/rain.yml/dispatches` with `{"ref":"main","inputs":{"environment":"production"}}`
- Use a fine-grained personal access token scoped to this repository only, with the permission _Actions: Read and write_.
- This keeps the rain and watering data inside the Mapbox tileset up to date.

## Maintenance

In addition to Step 4: monitor `rain.yml` in particular, since it is triggered daily by the cron job. If it fails, the rain and watering data in the Mapbox layer will be out of sync with the database.
