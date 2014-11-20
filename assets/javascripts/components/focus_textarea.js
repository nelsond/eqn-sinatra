var autoComplete = function (e) {
  var el = $(this),
    keyCode = e.keyCode || e.which,
    text = el.val(),
    caret = this.selectionStart,
    left = text.substr(0,caret),
    right = text.substring(caret, text.length);

  if (e.type == "keyup" && keyCode == 52) {
    if (/[^\\]\$$/.test(left) && !/^\$/.test(right)) {
      el.val(left + "$" + right);
      this.setSelectionRange(caret,caret);
    }
    if (/[^\\]\$\$$/.test(left) && !/^\$\$/.test(right)) {
      el.val(left + "$" + right);
      this.setSelectionRange(caret,caret);
    }
  }

  if (e.type == "keydown" && keyCode == 8 && /\$$/.test(left) && /^\$/.test(right)) {
    el.val(left + right.substring(1, right.length));
    this.setSelectionRange(caret, caret);
  }

}

var selectionStartSupported = !Ember.none($("<textarea/>").prop("selectionStart"));

Eqn.FocusTextareaComponent = Ember.TextArea.extend({
  becomeFocused: function() {
    this.$().focus();

    if (selectionStartSupported) {
      this.$().on("keyup", autoComplete);
      this.$().on("keydown", autoComplete);
    }
  }.on("didInsertElement"),
  destroyEditor: function() {
    if (selectionStartSupported) {
      this.$().off("keyup", autoComplete);
      this.$().off("keydown", autoComplete);
    }
  }.on("willDestroyElement")
});
