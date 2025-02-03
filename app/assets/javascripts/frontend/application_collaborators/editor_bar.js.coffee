window.ApplicationCollaboratorsEditorBar =

  render_collaborators_bar: () ->
    editor = ApplicationCollaboratorsAccessManager.current_editor()
    currentEditorName = editor.name + " (" + editor.email + ")"

    me = window.user_id

    if me == editor.id
      header = "You cannot edit this section unless you close it elsewhere first."
      message = "It looks like you have already opened this section in another tab or window. To avoid data-saving issues, you can only have it open in one tab or window at a time. Please close the other tabs or windows to continue editing."
    else
      header = "You are not able to work on this section at the moment."
      message = "Currently, #{currentEditorName} is working on this section. To avoid data-saving issues, only one person can work on a section at a time. Please work on another section or try this section later."

    $(".js-collaborators-bar").removeClass('hidden').html('
<div aria-labelledby="govuk-warning-banner-title" class="govuk-notification-banner" data-module="govuk-notification-banner" role="region">
  <div class="govuk-notification-banner__header">
    <div class="govuk-notification-banner__title" id="govuk-warning-banner-title">' + header + '</div>
  </div>
  <div class="govuk-notification-banner__content">
    <p class="govuk-body">' + message + '</p>
  </div>
</div>
    ')

  hide_collaborators_bar: () ->
    $(".js-collaborators-bar").addClass('hidden').text("")

  show_loading_bar: () ->
    $(".js-collaborators-bar").removeClass('hidden').html('
<div class="govuk-warning-text">
  <strong class="govuk-warning-text__text">Loading…</strong>
</div>
    ')
