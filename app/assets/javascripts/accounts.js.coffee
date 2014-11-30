jQuery ->
  ($ '#account-next-step').on 'click', (e) ->
    do e.preventDefault
    do ($ '#account-form').submit

  if ($ '#user_qae_info_source_other').length
    toggleOther = (checkbox) ->
      if checkbox.is(':checked')
        ($ '#qae_info_source_other').removeClass('visuallyhidden')
      else
        ($ '#qae_info_source_other').addClass('visuallyhidden')

    toggleOther($ '#user_qae_info_source_other')

    ($ '#user_qae_info_source_other').on 'change', ->
      toggleOther($ @)
