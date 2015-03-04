module FormAnswerHelper
  def application_flags(form_answer)
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

  def average_growth_for(form_answer, year)
    growth = form_answer.average_growth_for(year)
    growth || content_tag(:span, "-", class: "centered")
  end

  def average_growth_legend(form_answer, years = [1, 2, 3])
    growths = years.map { |y| form_answer.average_growth_for(y) }.uniq
    growths.map do |g|
      note = SICCode::NOTES[g]
      "#{g} - #{note}" if note
    end.compact.join("\n")
  end

  def sic_code(form_answer)
    code = form_answer.sic_code
    code || "-"
  end
end
