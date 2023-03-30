$(document).on('turbo:load', function() {
  $('.alert').delay(2500).animate({height:0, opacity: 0}, 500, function() {
    $(this).remove();
  });
});