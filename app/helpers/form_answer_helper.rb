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
    output = "<span class='icon-comment'>Comments: <span class='comment-count'>"
    if form_answer.comments.any?
      output += "#{form_answer.comments.size}"
    else
      output += "0"
    end
    output += "</span></span>"
    output.html_safe
  end

  def award_types_collection
    FormAnswerDecorator::SELECT_BOX_LABELS.invert.to_a
  end
end
