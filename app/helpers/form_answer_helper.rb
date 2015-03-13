module FormAnswerHelper
  def application_flags(comments)
    scope = namespace_name.equal?(:admin) ? :admin? : :critical?
    content_tag :span, class: "icon-flagged" do
      content_tag :span, class: "flag-count" do
        comments.select(&scope).size.to_s
      end
    end
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

  def sic_code(form_answer)
    code = form_answer.sic_code
    code || "-"
  end
end
