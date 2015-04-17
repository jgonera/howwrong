// TODO: Load this separately, maybe?
(function() {
  var KEY_ENTER = 13, KEY_SPACE = 32;

  function markChecked(el) {
    d3.select(el.parentNode).selectAll(".checkable").classed("checked", false);
    d3.select(el).classed("checked", true);
  }

  // This is ridiculous, d3 doesn't allow multiple on("click") callbacks?
  function advanceStage() {
    d3.select(".form-new .active + fieldset").classed("active", true);
    d3.select(".form-new .active").classed("active", false);
  }

  d3.selectAll(".checkable")
    .on("click", function() {
      markChecked(this);
    })
    .on("keyup", function() {
      var ev = d3.event;
      if (ev.which === KEY_ENTER || ev.which === KEY_SPACE) {
        markChecked(this);
      }
    });

  d3.selectAll(".form-new .button.next").on("click", function() {
    advanceStage();

    // Don't submit the form
    d3.event.preventDefault();
  });

  d3.select(".form-new .button-answers").on("click", function() {
    d3.selectAll(".form-new input.answer").each(function(d, i) {
      console.log(this);
      var checkable = d3.select(".form-new .checkable.answer:nth-of-type(" + (i + 1) + ")");

      if (this.value.length) {
        checkable.select("label").text(this.value);
      } else {
        checkable.style("display", "none");
      }
    });

    advanceStage();

    // Don't submit the form
    d3.event.preventDefault();
  });

}());
