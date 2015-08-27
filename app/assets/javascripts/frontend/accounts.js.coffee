jQuery ->
  ($ '#account-next-step').on 'click', (e) ->
    do e.preventDefault
    do ($ '#account-form').submit

  if $('#user_qae_info_source').size() > 0
    toggleOther = (select) ->
      if select.val() == 'other'
        ($ '#qae_info_source_other').removeClass('visuallyhidden')
      else
        ($ '#qae_info_source_other').addClass('visuallyhidden')

    toggleOther($ '#user_qae_info_source')

    ($ '#user_qae_info_source').on 'change', ->
      toggleOther($ @)

  if $(".account-notice").length
    $("form input").on "propertychange change keyup input paste", ->
      $(".account-notice").remove()
