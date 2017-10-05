const path = require("path");

module.exports = {
  entry: {
    facebookInjector: "./src/facebookInjector.js"
  },
  output: {
    filename: "[name].js",
    path: path.resolve(__dirname, "dist")
  },
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: ["elm-webpack-loader?debug=true"]
      }
    ]
  }
};
