var showdown = new Showdown.converter();

var mathReplacer = function(prefix) {
  prefix = Ember.none(prefix) ? "" : prefix;

  return function() {
    if (arguments.length < 2) { return ""; }

    var match = arguments[0],
        math = arguments[1];

    // replace escaped characters
    math = math.replace(/\\\\/gm, "\\");
    math = math.replace(/\\\$/gm, "$");

    var mathHtml;
    try {
      mathHtml = katex.renderToString(prefix + math);
    }
    catch (err) {
      mathHtml = "<span class=\"katex-error\">" + err.message + "</span>";
    }

    return " " + mathHtml + " ";
  }
};

Ember.Handlebars.helper("renderEquation", function(code) {
  var escaped = Handlebars.Utils.escapeExpression(code),
      inlineMathReplacer = mathReplacer,
      displayStyleMathReplacer = mathReplacer("\\displaystyle ");

  escaped = escaped.replace(/\$\$([^$\\]*(?:\\.[^$\\]*)*)\$\$/gim, displayStyleMathReplacer);
  escaped = escaped.replace(/\$([^$\\]*(?:\\.[^$\\]*)*)\$/gim, inlineMathReplacer);
  escaped = showdown.makeHtml(escaped.replace(/\\\$/gm, "$"));

  return new Ember.Handlebars.SafeString(escaped);
});

Ember.Handlebars.helper("formatTimestamp", function(ts) {
  return moment.unix(ts).calendar();
});

