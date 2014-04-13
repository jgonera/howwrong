(function() {
  var tapEvent = "ontouchstart" in window ? "touchend" : "click";
  var tooltip = d3.select(".share .tooltip").on(tapEvent, function() {
    d3.event.stopPropagation();
  });
  var nav = d3.select("nav ul");

  d3.select(".share .link").on(tapEvent, function() {
    d3.event.stopPropagation();
    tooltip.classed("visible", true);
    tooltip.select("input").node().select();
  });

  d3.select("body").on(tapEvent, function() {
    tooltip.classed("visible", false);
  });

  d3.select("#hamburger").on(tapEvent, function() {
    nav.classed("visible", !nav.classed("visible"));
  });
}());
