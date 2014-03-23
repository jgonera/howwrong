$(function() {
  var KEY_ENTER = 13, KEY_SPACE = 32;

  $('[role="button"]')
    .on("click", function() {
        $(this).closest("form").submit();
    })
    .on("keyup", function(ev) {
      var $el = $(this);
      if (ev.which === KEY_ENTER || ev.which === KEY_SPACE) {
        $el.find("input").prop("checked", true);
        $el.click();
      }
    });
});
