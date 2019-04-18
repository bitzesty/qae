window.customFormUiHelpers =
  init: ->
    customFormUiHelpers.view_gov_departments_and_agencies_link_init()

  view_gov_departments_and_agencies_link_init: () ->
    $(document).on 'click', '.js-form-expandable-content-link', ->
      link = $(this);
      content_block = $("." + link.data('ref'));

      if content_block.hasClass('hidden')
        content_block.removeClass('hidden');
      else
        content_block.addClass('hidden');

      return false;

jQuery ->
  window.customFormUiHelpers.init();