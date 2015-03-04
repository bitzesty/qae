module EligibilityHelper
  def final_eligibility_page?(step)
    !step || step.to_s == "wicked_finish"
  end
end
