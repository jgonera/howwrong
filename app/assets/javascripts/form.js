(function() {
  var KEY_ENTER = 13, KEY_SPACE = 32;

  function submit(el) {
    d3.select(el).select('input[type="radio"]').property('checked', true);
    d3.select(".vote-form").node().submit();
  }

  function markChecked(el) {
    d3.select(el.parentNode).selectAll(".checkable").classed("checked", false);
    d3.select(el).classed("checked", true);
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

  d3.selectAll('.vote-form [role="button"]')
    .on("click", function() {
      submit(this);
    })
    .on("keyup", function() {
      var ev = d3.event;
      if (ev.which === KEY_ENTER || ev.which === KEY_SPACE) {
        submit(this);
      }
    });
}());
