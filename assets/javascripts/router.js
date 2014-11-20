Eqn.EquationsShowRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find("equation", params.equation_id);
  }
});

Eqn.EquationsNewRoute = Ember.Route.extend({
  model: function() {
    var code = Ember.none(Storage) ? null : localStorage.getItem("equations:new:code");

    return this.store.createRecord("equation", {
      code:  Ember.none(code) ? "" : code
    });
  }
});

Eqn.EquationsHelpRoute = Em.Route.extend({
  model: function() {
    var self = this;
    return new Ember.RSVP.Promise(function(resolve, reject) {
      $.get("/help.md").then(function(code) {
         var equation = self.store.createRecord("equation", {
          code: code
        });
        resolve(equation);
      }).fail(reject);
    });
  }
});
