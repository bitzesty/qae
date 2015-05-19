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
end
