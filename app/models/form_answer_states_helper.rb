module FormAnswerStatesHelper
  def recommended?
    state == "recommended"
  end

  def awarded?
    state == "awarded"
  end

  def unsuccessful?
    [
      "not_recommended",
      "not_awarded"
    ].include?(state)
  end

  def submitted_and_after_the_deadline?
    submitted? && Settings.after_current_submission_deadline?
  end
end
