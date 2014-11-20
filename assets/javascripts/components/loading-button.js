Eqn.LoadingButtonComponent = Ember.Component.extend({
  buttonText: "Save",
  isLoading: false,

  actions: {
    showLoading: function() {
      var isLoading = this.get("isLoading");

      if (!isLoading) {
        this.set("isLoading", true);
        this.sendAction("action");
      }
    }
  }
});
