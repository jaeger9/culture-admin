var path = require('path');
var _ = require('lodash');
var webpack = require('webpack');
var MiniCssExtractPlugin = require('mini-css-extract-plugin');
var postcssPresetEnv = require('postcss-preset-env');

const entries = {
    'index': ['core-js/stable', 'regenerator-runtime/runtime', './index'],
};

var staging = process.env.NODE_ENV || 'development';

console.log(`Current Staging: ${staging}`);

const isDevelopment = (staging === 'development');

console.log('isDevelopment = ' + isDevelopment);

var plugins = [
    new webpack.ProvidePlugin({
        'jQuery': 'jquery',
        '$': 'jquery',
    }),
    new webpack.ContextReplacementPlugin(/moment[/\\]locale$/, /^(en|ko)$/),
    new MiniCssExtractPlugin({
        // Options similar to the same options in webpackOptions.output
        // both options are optional
        filename: 'css/[name].bundle.css',
        chunkFilename: '[id].bundle.css',
        ignoreOrder: false,
    }),
];

// setup plugins for each staging.
if (isDevelopment) {
    plugins.push(
        new webpack.SourceMapDevToolPlugin({
            test: /.*\.(js|jsx|css|scss)/,
            exclude: /^node_modules/,
            module: true,
            columns: true,
            filename: '[file].map'
        })
    );
} else {
    plugins.push(
        new webpack.SourceMapDevToolPlugin({
            test: /.*\.(js|jsx|css|scss)/,
            exclude: /^node_modules/,
            module: false,
            columns: false,
            filename: '[file].map'
        })
    );
}

var config = {
    mode: (staging || 'production'),
    context: path.resolve(__dirname, 'src'),
    entry: entries,
    resolve: {
        extensions: ['.jsx', '.js', '.json'],
        modules: [
            path.resolve(__dirname, 'src'),
            'node_modules'
        ]
        // extensions: ['', '.js', '.jsx']
    },
    output: {
        filename: '[name].bundle.js',
        chunkFilename: '[name].bundle.js',
        path: path.resolve(__dirname, 'dist/bundles'),
        publicPath: '/bundles/',
    },
    optimization: {
        splitChunks: {
            cacheGroups: {
                vendor: {
                    test: /([\\/]node_modules[\\/]|libs[\\/](.*)\.[jJ][sS](|[xX])$|ads[\\/]|libs[\\/](.*)\.[jJ][sS][oO][nN]$|ads[\\/]|league[\\/]club[\\/]clubs.json)/,
                    name: 'vendor',
                    chunks: 'all'
                }
            }
        }
    },
    devtool: (isDevelopment ? 'eval' : false),  // source-map is not working https://github.com/webpack/webpack/issues/5491
    plugins: plugins,
    module: {
        rules: [
            {
                test: /\.jsx$/,
                exclude: /node_modules/,
                use: [
                    {
                        loader: 'babel-loader',
                        options: {
                            presets: [
                                ['@babel/env', {
                                    "targets": {
                                        "browsers": ["last 4 versions"]
                                    },
                                    // "targets": "> 0.25%, not dead",  // <== 2018.08   "android": "4.4","chrome": "29","edge": "16","firefox": "52","ie": "11","ios": "9.3", "safari": "11.1"
                                    "useBuiltIns": 'entry',
                                    "corejs": 3,
                                    "debug": isDevelopment
                                }],
                                ['@babel/react', {
                                    development: isDevelopment,
                                }]
                            ],
                            cacheDirectory: isDevelopment,
                            babelrc: false,
                        }
                    }
                ]
            },
            {
                test: /\.(sa|sc|c)ss$/i,
                use: [
                    {
                        loader: MiniCssExtractPlugin.loader,
                        options: {
                            hmr: process.env.NODE_ENV === 'development',
                        },
                    },
                    {
                        loader: 'css-loader',
                        options: {
                            modules: 'global',
                            import: true,
                            sourceMap: isDevelopment
                        }
                    },
                    {
                        loader: 'postcss-loader',
                        options: {
                            ident: 'postcss',
                            plugins: function(){
                                return [ postcssPresetEnv({
                                    browsers: ["last 4 versions"]
                                }) ]
                            },
                            sourceMap: isDevelopment
                        }
                    },
                    {
                        loader: 'sass-loader',
                        options: {
                            sourceMap: isDevelopment,
                            includePaths: [
                                path.join(__dirname, 'node_modules')
                            ],
                        }
                    }
                ]
            },
            {
                test: /\.pug$/,
                exclude: /node_modules/,
                use: [
                    {
                        loader: 'pug-loader',
                        options: {
                            pretty: isDevelopment
                        }
                    }
                ],
            },
            {
                test: /.*\.(gif|png|jpe?g|svg)$/i,
                use: [
                    {
                        loader: 'file-loader',
                        options: {
                            hash: 'sha512',
                            digest: 'hex',
                            name: 'images/[hash].[ext]'
                        }
                    },
                    {
                        loader: 'image-webpack-loader',
                        options: {
                            query: {
                                bypassOnDebug: true,
                                progressive: true,
                                optimizationLevel: 7,
                                interlaced: false,
                                mozjpeg: {
                                    progressive: true,
                                },
                                gifsicle: {
                                    interlaced: false,
                                },
                                optipng: {
                                    optimizationLevel: 4,
                                },
                                pngquant: {
                                    quality: '65-90',
                                    speed: 4
                                }
                            }
                        }
                    },
                ]
            },
            {
                test: require.resolve('jquery'),
                use: [
                    {
                        loader: 'expose-loader',
                        query: 'jQuery'
                    },
                    {
                        loader: 'expose-loader',
                        query: '$'
                    }
                ]
            }
        ]
    },
    watchOptions: {
        aggregateTimeout: 1000,
        poll: false
    },
    devServer: {
        contentBase: path.join(__dirname, 'dist'),
        compress: true,
        port: 9999,
        proxy: {
            context: function() {
                return true;
            },
            target: 'http://localhost:8080'
        }
    }
};

if (!isDevelopment) {
    config.plugins.push(
        new webpack.DefinePlugin({
            'process.env': {
                'NODE_ENV': JSON.stringify('production')
            }
        })
    );
}

module.exports = config;

module.exports.node = {
    child_process: 'empty'
};
