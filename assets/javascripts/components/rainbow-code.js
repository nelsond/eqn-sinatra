Rainbow.extend("katex", [
  {
    name: "command",
    pattern: /(\\([^\\\s{}^_$]|\\[^\s])+)/g
  },
  {
    matches: {
      1: "bracket",
      2: "bracket",
      3: "content",
      4: "bracket"
    },
    pattern: /([_^]?)({)((?:[^\\{]|\\.)*)(})/g
  },
], true);

var render = function(target) {
  Rainbow.color(target.get("code"), target.get("language"), function(result) {
    target.set("highlightedCode", result);
  });
};

Eqn.RainbowCodeComponent = Ember.Component.extend({
  code: "",
  highlightedCode: "",
  language: "default",

  codeObserver: function () {
    render(this);
  }.observes("code"),

  initializeHighlightedCode: function() {
    render(this);
  }.on("didInsertElement")
});
