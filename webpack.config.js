const HtmlWebpackPlugin = require('html-webpack-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const webpack = require('webpack');
const path = require('path');

const currentTask = process.env.npm_lifecycle_event;

const coffeeConfig = {
	test: /\.coffee$/,
	loader: 'coffee-loader',
	options: {
		bare: false,
		transpile: {
			presets: ['@babel/env'],
			plugins: ['@babel/plugin-transform-runtime'],
		},
	},
};

const stylusConfig = {
	test: /\.styl$/,
	use: [
		'style-loader',
		'css-loader',
		{
			loader: 'stylus-loader',
			options: {
				sourceMap: currentTask == 'watch' ? true : false,
				stylusOptions: {
					use: ['autoprefixer-stylus'],
				},
			},
		},
	],
};

const cssConfig = {
	test: /\.css$/,
	use: ['style-loader', 'css-loader', 'css-min-loader'],
};

const pugConfig = {
	test: /\.pug$/,
	loader: 'pug-loader',
	options: {
		pretty: true,
	},
};

const fileConfig = {
	test: /\.(jpg|jpeg|png|svg|ico)$/,
	use: {
		loader: 'file-loader',
		options: {
			name: '[name].[ext]',
			outputPath: 'images/',
			publicPath: 'images/',
		},
	},
};

const pages = [
	{
		title: 'Main Page',
		template: path.resolve(__dirname, './app/pages/index.html'),
		output: 'index.html',
		jsName: 'script',
		jsPath: path.resolve(__dirname, './app/pages/script.coffee'),
	},
	{
		title: 'Profile Page',
		template: path.resolve(__dirname, './app/pages/profile.html'),
		output: 'profile.html',
		jsName: 'script',
		jsPath: path.resolve(__dirname, './app/pages/script.coffee'),
	},
];

let entries = new Object();
let plugins = [
	new webpack.ProvidePlugin({
		$: 'jquery',
	}),
];

const rules = [coffeeConfig, stylusConfig, cssConfig, pugConfig, fileConfig];

let config = [];

switch (currentTask) {
	case 'watch':
		plugins.push(
			new CleanWebpackPlugin({
				cleanStaleWebpackAssets: false,
			}),
			new webpack.SourceMapDevToolPlugin({
				filename: '[name].js.map',
			})
		);
		pages.forEach((page) => {
			entries[page.jsName] = page.jsPath;
			plugins.push(
				new HtmlWebpackPlugin({
					title: page.title,
					filename: page.output,
					chunks: [page.jsName],
					inject: false,
					template: page.template,
				})
			);
		});
		config = [
			{
				entry: entries,
				context: path.resolve(__dirname),
				output: {
					filename: '[name].bundle.js',
					path: path.resolve(__dirname, 'dist'),
					clean: true,
				},
				mode: 'development',
				watch: true,
				module: {
					rules: rules,
				},
				plugins: plugins,
			},
		];
		break;

	case 'build':
		pages.forEach((page) => {
			entries[page.jsName] = page.jsPath;
			plugins.push(
				new HtmlWebpackPlugin({
					title: page.title,
					filename: page.output,
					chunks: [page.jsName],
					inject: false,
					template: page.template,
				})
			);
		});
		config = [
			{
				entry: entries,
				context: path.resolve(__dirname),
				output: {
					filename: '[name].bundle.js',
					path: path.resolve(__dirname, 'prod'),
				},
				mode: 'production',
				module: {
					rules: rules,
				},
				plugins: plugins,
			},
		];
		break;
}

module.exports = config;
