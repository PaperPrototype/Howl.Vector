import { defineConfig } from "vite";
import haxe from "vite-plugin-haxe";

/** @type {import('vite').UserConfig} */
export default defineConfig({
  plugins: [haxe()],
});