import { defineConfig } from 'vite';
import coffee from 'vite-plugin-coffee';
import { resolve } from 'path';

export default defineConfig({
	plugins: [
		coffee({
			// Set to true if you use react
			jsx: false,
		}),
	],
	fs: {
		// Allow serving files from one level up to the project root
		allow: ['..'],
	},
	build: {
		rollupOptions: {
			input: {
				index: resolve(__dirname, './index.html'),
				profile: resolve(__dirname, './profile.html'),
			},
		},
	},
});
