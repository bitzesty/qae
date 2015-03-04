module EligibilityHelper
  def final_eligibility_page?(step)
    !step || step != "wicked_finish"
  end
end
