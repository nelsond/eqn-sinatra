Eqn.EquationsController = Ember.ObjectController.extend({
  isLoading: false,
});

Eqn.EquationsNewController = Eqn.EquationsController.extend({
  isValid: false,
  validObserver: function() {
    var isValid = !Ember.empty(this.get("code"));
    this.set("isValid", isValid);
  }.observes("code"),
  valuesObserver: function() {
    if (!Ember.none(Storage)) localStorage.setItem("equations:new:code", this.get("code"));
  }.observes("code"),

  actions: {
    createEquation: function() {
      if (!this.get("isValid")) {
        alert("Can't save blank equation.");
        return;
      }

      this.set("isLoading", true);
      var equation = this.store.createRecord("equation", {
        code: this.get("code")
      });

      if (!Ember.none(Storage)) localStorage.removeItem("equations:new:code");

      var self = this;
      equation.save().then(function(equation) {
        self.set("isLoading", false);
        self.transitionToRoute("equations.show", equation);
      });
    }
  }
});

Eqn.EquationsShowController = Eqn.EquationsController.extend({
  continueIsAvailable: false,
  continueObserver: function() {
    var continueIsAvailable = !Ember.none(Storage) && !Ember.empty(localStorage.getItem("equations:new:code"));
    this.set("continueIsAvailable", continueIsAvailable);
  }.observes("code"),
  actions: {
    forkEquation: function() {
      if (!Ember.none(Storage)) localStorage.setItem("equations:new:code", this.get("code"));

      this.transitionToRoute("equations.new");
    }
  }
});

Eqn.EquationsHelpController = Eqn.EquationsShowController.extend({});
