module("Integration Tests", {
  teardown: function() {
    Eqn.reset();
  }
});

test("/ shows new equation form and preview", function() {
  visit("/");

  andThen(function() {
    equal(find("#editor textarea").length, 1, "The page should have syntax textarea");
    equal(find("#preview .markdown").length, 1, "The page should have preview");
  });
});

test("/ shows preview on input", function() {
  visit("/");
  fillIn("#editor textarea", "$\\int$");

  andThen(function() {
    equal(find("#preview .markdown .katex").length, 1, "The preview should contain KaTex");
  });
});

test("/ saves new equation", function () {
  var code = "# This is a heading";

  stubEndpointForHttpRequest("/equations", "POST", {
    equation: {
      id: "abcd",
      code: code,
      created_at: nowTimestamp()
    }
  });

  visit("/");
  fillIn("#editor textarea", code);
  click(".save a");

  andThen(function() {
    equal(find("#equation .markdown h1").length, 1, "The equation should have a heading");
  });
});

test("/ does not save empty equation", function() {
  visit("/");
  click(".save a");

  andThen(function() {
    equal(find("#equation").length, 0, "The page should not contain an equation");
  });
});

test("/:equation_id shows equation", function () {
  var id = "abcd";

  stubEquation(id, "# This is a heading");
  visit("/"+id);

  andThen(function() {
    notEqual(
      find(".meta").text().match(/[0-9]{1,2}:[0-9]{2}\s(AM|PM)[^\d]*[0-9]+\schars/i),
      null,
      "The page should contain equation meta data"
    );

    equal(find("#equation").length, 1, "The page should not contain the equation");
    equal(find("#equation .markdown h1").length, 1, "The equation should have a heading");
  });
});

test("/:equation_id shows source", function () {
  var id = "abcd",
      code = "# This is a heading";

  stubEquation(id, code);
  visit("/"+id);
  click(".switch");

  andThen(function() {
    equal(find("#equation pre").html(), code, "The source should be shown");
  });
});
