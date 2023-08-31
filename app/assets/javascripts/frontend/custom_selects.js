$(document).ready(function () {
  $('.custom-select').each(function () {
    var field = $(this)[0];

    if ($(this).is(':disabled') || $(this).is('[readonly]')) {
      return;
    }

    accessibleAutocomplete.enhanceSelectElement({
      selectElement: field,
      showAllValues: true,
      dropdownArrow: () => {
        return "<span class='autocomplete__arrow'></span>";
      },
    });
  });

  const observer = new MutationObserver((mutations) => {
    return mutations.forEach((mutation) => {
      return mutation.addedNodes.forEach((node) => {
        if (node instanceof HTMLElement) {
          const elements = node.querySelectorAll('select.custom-select');
          if (elements.length > 0) {
            Array.from(elements).forEach((element) => {
              accessibleAutocomplete.enhanceSelectElement({
                selectElement: element,
                showAllValues: true,
                dropdownArrow: () => {
                  return "<span class='autocomplete__arrow'></span>";
                },
              });
            });
          }
        }
      });
    });
  });

  observer.observe(document.body, {
    subtree: true,
    childList: true,
  });
});
