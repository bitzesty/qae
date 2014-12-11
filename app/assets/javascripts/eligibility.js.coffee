jQuery ->
  if ($ '.eligibility_current_holder_of_qae_for_trade').length
    toggleOther = () ->
      if ($ '#eligibility_current_holder_of_qae_for_trade_true').is(':checked')
        ($ '.eligibility_qae_for_trade_expiery_date').removeClass('visuallyhidden')
      else
        ($ '.eligibility_qae_for_trade_expiery_date').addClass('visuallyhidden')

    toggleOther()
    ($ '#eligibility_current_holder_of_qae_for_trade_true, #eligibility_current_holder_of_qae_for_trade_false').on 'change', ->
      toggleOther()
