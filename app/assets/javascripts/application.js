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
//= require jquery
//= require turbolinks
//= require retina

$(function() {
  var $tooltip = $(".share .tooltip").on("click", function(ev) {
    ev.stopPropagation();
  });
  var $nav = $("nav ul");
  var tapEvent = "ontouchstart" in window ? "touchend" : "click";

  $(".share .link").on("click", function(ev) {
    ev.stopPropagation();
    $tooltip.addClass("visible");
    $tooltip.find("input").select();
  });

  $("body").on("click", function() {
    $tooltip.removeClass("visible");
  });

  $("#hamburger").on(tapEvent, function() {
    $nav.toggleClass("visible");
  });
});
