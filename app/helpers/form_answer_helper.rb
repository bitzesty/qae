module FormAnswerHelper
  def application_flags(comments)
    content_tag :span, class: "icon-flagged" do
      content_tag :span, class: "flag-count" do
        comments.select do |c|
          c.main_for?(current_subject) && c.flagged?
        end.size.to_s
      end
    end
  end

  def application_comments(comments)
    visible_comments = comments.select do |c|
      c.main_for?(current_subject)
    end

    return unless visible_comments.present?

    output = "<span class='icon-comment'>Comments: <span class='comment-count'>"
    output += "#{visible_comments.size}"
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
