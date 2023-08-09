const webpack = require('webpack');
const { merge, webpackConfig } = require('@rails/webpacker');

const customConfig = {
  plugins: [
    new webpack.ProvidePlugin({
      ApplicationController: ['application_controller', 'default'],
    }),
  ],
  resolve: {
    extensions: ['.css', '.scss'],
  },
};

module.exports = merge(webpackConfig, customConfig);
