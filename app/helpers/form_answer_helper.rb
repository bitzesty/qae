module FormAnswerHelper
  def application_flags(form_answer)
    # IMPLEMENTME
    output = ""
    if form_answer.important?
      output += "IMPORTANT"
    end
  end
end