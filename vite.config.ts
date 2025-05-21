import { defineConfig } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';

export default defineConfig({
	plugins: [svelte()],
	root: 'src/renderer',
	build: {
		outDir: '../../dist/renderer',
		emptyOutDir: true
	},
	base: './'
});
