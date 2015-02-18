module FormAnswerHelper
  def application_flags(form_answer)
    # TODO implement me
    output = ""
    if form_answer.important?
      output += "<span class='icon-flagged'>Flagged</span>"
    else
      output += "<span class='icon-unflagged'>Unflagged</span>"
    end
    output.html_safe
  end

  def application_comments(form_answer)
    output = ""
    if form_answer.comments.any?
      output += "<span class='icon-comment'>Comments: <span class='comment-count'>#{form_answer.comments.size}</span></span>"
    end
    output.html_safe
  end
end