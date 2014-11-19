window.Eqn = Ember.Application.create({});

Eqn.EquationAdapter = DS.RESTAdapter.extend({
  namespace: "api/v1"
});

//Eqn.EquationAdapter = DS.FixtureAdapter.extend();

Eqn.Router.reopen({
  location: "history"
});

Eqn.Router.map(function() {
  this.resource("equations", { path: "/" }, function () {
    this.route("new", { path: "/" });
    this.route("show", { path: "/:equation_id" });
  });
});
