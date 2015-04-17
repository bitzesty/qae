jQuery ->
  if ($ '.eligibility_current_holder_of_qae_for_trade').length
    toggleOther = () ->
      if ($ '#eligibility_current_holder_of_qae_for_trade_true').is(':checked')
        ($ '.eligibility_qae_for_trade_award_year').closest(".question").removeClass('visuallyhidden')
      else
        ($ '.eligibility_qae_for_trade_award_year').closest(".question").addClass('visuallyhidden')

    toggleOther()
    ($ '#eligibility_current_holder_of_qae_for_trade_true, #eligibility_current_holder_of_qae_for_trade_false').on 'change', ->
      toggleOther()
