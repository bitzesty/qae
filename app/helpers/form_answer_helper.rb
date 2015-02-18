module FormAnswerHelper
  def application_flags(form_answer)
    # IMPLEMENTME
    output = ""
    if form_answer.important?
      output += "IMPORTANT"
    end

    if form_answer.comments.any?
      output += "COMMENTS: #{form_answer.comments.size}"
    end

    output

  end
end