$(document).ready(function() {
  $('span.translation_missing').contextmenu(function(event) {
    key = $(this).attr("title")
    window.open("/i18nline/find_by_key?key=" + key, "_blank");
    return false; //prevent context menu to show
  });
  $('span.translation_found').contextmenu(function(event) {
    key = $(this).attr("title")
    window.open("/i18nline/find_by_key?key=" + key, "_blank");
    return false; //prevent context menu to show
  });
});
