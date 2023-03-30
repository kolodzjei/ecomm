$(document).on('turbo:load',function() {
  $('input[type="file"]').change(function(e){
    var fileSize = this.files[0].size;
    var maxSize = 5 * 1024 * 1024; // 5MB
    if(fileSize > maxSize){
      alert('File cant be larger than 5MB. Please choose other file.');
      $(this).val('');
    }
  });
});