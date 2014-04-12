// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require d3
//= require retina

(function() {
  var tooltip = d3.select(".share .tooltip").on("click", function() {
    d3.event.stopPropagation();
  });
  var nav = d3.select("nav ul");
  var tapEvent = "ontouchstart" in window ? "touchend" : "click";

  d3.select(".share .link").on("click", function() {
    d3.event.stopPropagation();
    tooltip.classed("visible", true);
    tooltip.select("input").node().select();
  });

  d3.select("body").on("click", function() {
    tooltip.classed("visible", false);
  });

  d3.select("#hamburger").on(tapEvent, function() {
    nav.classed("visible", !nav.classed("visible"));
  });
}());
