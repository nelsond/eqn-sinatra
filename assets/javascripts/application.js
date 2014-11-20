window.Eqn = Ember.Application.create({});

Eqn.EquationAdapter = DS.RESTAdapter.extend({
  namespace: "api/v1"
});

Eqn.Router.reopen({
  location: "history"
});

Eqn.Router.map(function() {
  this.resource("equations", { path: "/" }, function () {
    this.route("new", { path: "/" });
    this.route("show", { path: "/e/:equation_id" });
    this.route("help");
  });
});

Eqn.ErrorRoute = Ember.Route.extend();
