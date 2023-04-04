$(document).on('turbo:load',function() {
  $('#price-range input').on('change', function() {
    var min = parseFloat($('#price-range input')[0].value);
    var max = parseFloat($('#price-range input')[1].value);
    if(min > max){
      $('#price-range-error').show();
      $('input[type="submit"]').prop('disabled', true);
    }else{
      $('#price-range-error').hide();
      $('input[type="submit"]').prop('disabled', false);
    }
  });
});
    
    