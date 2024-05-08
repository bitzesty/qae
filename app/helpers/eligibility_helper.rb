module EligibilityHelper
  def final_eligibility_page?(step)
    !step || step.to_s == "wicked_finish"
  end

  def eligibility_tax_returns_question_ops
    [
      ["Yes", "true"], 
      ["No", "false"], 
      ["N/A", "na"],
    ]
  end

  def eligibility_tax_returns_formatted_answer(answer)
    case answer
    when "true"
      "Yes"
    when "false"
      "No"
    when "na"
      "N/A"
    end
  end
end
