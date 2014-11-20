window.Eqn = Ember.Application.create({});

Eqn.EquationAdapter = DS.RESTAdapter.extend({
  namespace: "api/v1"
});
