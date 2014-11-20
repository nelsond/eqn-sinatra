var hideFlash = function() {
  this.$().find("#flash").addClass("hidden");
};

var resetFlash = function() {
  this.$().find("#flash").removeClass("hidden");
  this.set("message", null);
};

Eqn.FlashMessageComponent = Ember.Component.extend({
  message: null,
  duration: 2000,
  messageObserver: function() {
    var message = this.get("message");

    if (message) {
      var duration = this.get("duration");

      this.$().show();

      Ember.run.debounce(this, hideFlash, duration);
      Ember.run.debounce(this, resetFlash, duration+500);
    } else {
      this.$().hide();
    }
  }.observes("message"),

  hideFlash: function() {
    this.$().hide();
  }.on("didInsertElement")
});
