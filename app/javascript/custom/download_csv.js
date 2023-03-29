$(document).ready(function() {
  var downloadButton = $('#download-csv');
  downloadButton.click(function() {

    downloadButton.off('click');

    $.ajax({
      url: '/admin/summary/download_csv',
      method: 'POST',
      data: { start_date: $('#start_date').val(), end_date: $('#end_date').val() },
      beforeSend: function() {
        downloadButton.html('Generating CSV...');
        downloadButton.prop('disabled', true);
      },
      success: function(data) {
        var job_id = data.job_id;
        checkJobStatus(job_id);
      },
      error: function() {
        downloadButton.html('Download CSV');
        downloadButton.prop('disabled', false);
        alert('Error generating CSV. Please try again.');
      }
    });
  });

  function checkJobStatus(job_id) {
    var interval = setInterval(function() {
      $.ajax({
        url: '/admin/summary/check_job_status',
        method: 'GET',
        data: { job_id: job_id },
        success: function(data) {
          if (data.status == 'complete') {
            clearInterval(interval);
            downloadButton.html('Download CSV');
            downloadButton.prop('disabled', false);
            downloadButton.attr('href', data.download_url);
            downloadButton.off('click');
            setTimeout(function() {
              downloadButton.html('Download expired');
              downloadButton.prop('disabled', true);
              downloadButton.attr('href', '#');
            }, 60000);
          }
        }
      });
    }, 5000);
  }
});