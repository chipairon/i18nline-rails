$(document).ready(function() {
  $('span.translation_missing').off("contextmenu").on("contextmenu", function(event) {
    event.preventDefault();
    event.stopPropagation();
    key = $(this).attr("title");
    window.open("/i18nline/find_by_key?key=" + key, "_blank");
  });
  $('span.translation_found').off("contextmenu").on("contextmenu", function(event) {
    event.preventDefault();
    event.stopPropagation();
    key = $(this).attr("title");
    window.open("/i18nline/find_by_key?key=" + key, "_blank");
  });
});
