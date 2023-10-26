$(document).on("input", ".matrix-question-input", function() {
  // allow only numbers on input
  this.value = this.value.replace(/\D/g,'');
});
