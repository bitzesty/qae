$(document).ready(function() {
  $(".govuk-select").each(function() {
    var field = $(this)[0];

    if ($(this).is(":disabled") || $(this).is("[readonly]")) {
      return;
    }

    accessibleAutocomplete.enhanceSelectElement({
      selectElement: field,
      showAllValues: true, 
      dropdownArrow: function() {
        return "<span class='autocomplete__arrow'></span>";
      }
    })
  });
});