(function() {
  function showTimeZone() {
    var timezone = jstz.determine();
    jQuery('#time-zone').text(timezone.name());
  }

  function initDateTimePicker() {
    var minDate = new Date();
    minDate.setMinutes(0);
    minDate.setSeconds(0);
    minDate.setMilliseconds(0);
    minDate.setHours(minDate.getHours() + 2);

    jQuery('#reservation_form_datetime').datetimepicker({
      format: 'M j, Y g:i a',
      formatTime: 'g:i A',
      minDate: minDate,
      defaultTime: minDate,
      timepickerScrollbar: false
    });
  }

  $(document).ready(function() {
    showTimeZone();
    initDateTimePicker();
  });
})();
