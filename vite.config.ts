import { defineConfig, type Plugin } from "vite";
import react from "@vitejs/plugin-react";

// Docker image (`vite build --mode docker`): read VITE_* from window.__ENV__
// at runtime instead of baking them in at build time. /env.js is written on
// container start by docker/40-env.sh.
const runtimeEnv: Plugin = {
	name: "runtime-env",
	enforce: "pre",
	apply: (_, { mode }) => mode === "docker",
	transform(code, id) {
		return /\/src\/.*\.tsx?$/.test(id)
			? code.replace(/import\.meta\.env\.(VITE_\w+)/g, "window.__ENV__.$1")
			: null;
	},
	transformIndexHtml: () => [
		{ tag: "script", attrs: { src: "/env.js" }, injectTo: "head-prepend" },
	],
};

// https://vitejs.dev/config/
export default defineConfig({
	plugins: [react(), runtimeEnv],
});
