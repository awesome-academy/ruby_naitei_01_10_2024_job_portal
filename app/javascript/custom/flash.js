document.addEventListener('turbo:load', function() {
  setTimeout(function() {
    var alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
      alert.style.opacity = '0';
      setTimeout(function() {
        alert.remove();
      }, 1000);
    });
  }, 15000);

  document.querySelectorAll('.alert .close').forEach(function(button) {
    button.addEventListener('click', function() {
      var alert = this.closest('.alert');
      alert.style.opacity = '0';
      setTimeout(function() {
        alert.remove();
      }, 1000);
    });
  });
});
