module.exports = function(config) {
  config.set({
    basePath: "",
    frameworks: ["qunit"],
    files: [
      "lib/jquery.js",
      "lib/katex.js",
      "lib/moment.js",
      "lib/jquery.mockjax.js",
      "lib/ZeroClipboard.js",
      "lib/showdown.js",
      "lib/rainbow.js",
      "lib/handlebars-v1.1.0.js",
      "lib/ember.js",
      "lib/ember-data.js",
      "application.js",
      "components/*.js",
      "helpers.js",
      "models/*.js",
      "controllers/*.js",
      "router.js",
      "templates/*.hbs",
      "templates/**/*.hbs",
      "tests/helper.js",
      "tests/integration.js"
    ],
    plugins: [
     "karma-qunit",
     "karma-ember-preprocessor",
     "karma-phantomjs-launcher"
   ],
    preprocessors: {
      "**/*.hbs": "ember"
    },
    reporters: ["progress"],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ["PhantomJS"],
    singleRun: false
  });
};
