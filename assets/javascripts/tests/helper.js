Eqn.setupForTesting();
Eqn.injectTestHelpers();

$.mockjaxSettings.responseTime = 0;
$.mockjaxSettings.logging = false;

function nowTimestamp() {
  return Math.floor( (new Date()).getTime()/1000 );
}

function stubEndpointForHttpRequest(path, type, json) {
  $.mockjax({
    url: "/api/v1" + path,
    type: type,
    dataType: "json",
    responseText: json
  });
}

function stubEquation(id, code, timestamp) {
  stubEndpointForHttpRequest("/equations/"+id, "GET", {
    equation: {
      id: id,
      code: code,
      timestamp: timestamp || nowTimestamp()
    }
  });
}
