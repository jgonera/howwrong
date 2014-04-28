(function() {
  var tapEvent = "ontouchstart" in window ? "touchend" : "click",
      tooltip = d3.select(".share .tooltip"),
      nav = d3.select("nav ul"),
      body = d3.select("body");

  function markScrolled() {
    body.classed("scrolled", window.scrollY !== 0);
  }

  tooltip.on(tapEvent, function() {
    d3.event.stopPropagation();
  });

  d3.select(".share .link").on(tapEvent, function() {
    d3.event.stopPropagation();
    tooltip.classed("visible", true);
    tooltip.select("input").node().select();
  });

  body.on(tapEvent, function() {
    tooltip.classed("visible", false);
  });

  d3.select("#hamburger").on(tapEvent, function() {
    nav.classed("visible", !nav.classed("visible"));
  });

  d3.select(window)
    .on("scroll", markScrolled)
    .on("touchmove", markScrolled);
  markScrolled();
}());
