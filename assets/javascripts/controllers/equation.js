Eqn.EquationsController = Ember.ObjectController.extend({
  valuesObserver: function() {
    $.cookie("equations:new:code", this.get("code"));
  }.observes("code"),

  actions: {
    forkEquation: function() {
      console.log(this.get("model.code"));
      $.cookie("equations:new:code", this.get("model.code"));
      this.transitionToRoute("equations.new");
    },
    createEquation: function() {
      var equation = this.store.createRecord("equation", {
        code: this.get("code")
      });

      $.removeCookie("equations:new:code");

      var self = this;
      equation.save().then(function(equation) {
        self.transitionToRoute("equations.show", equation);
      });
    }
  }
});

Eqn.EquationsNewController = Eqn.EquationsController.extend();
Eqn.EquationsShowController = Eqn.EquationsController.extend();
