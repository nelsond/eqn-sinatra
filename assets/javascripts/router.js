equationNotFound = function(reason) {
  console.log("Equation not found", $.parseJSON(reason.responseText));
};
Eqn.EquationsShowRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find("equation", params.equation_id).catch(equationNotFound);
  }
});

Eqn.EquationsNewRoute = Ember.Route.extend({
  model: function() {
    var code = $.cookie("equations:new:code");

    return this.store.createRecord("equation", {
      code:  Ember.none(code) ? "" : code
    });
  }
});
