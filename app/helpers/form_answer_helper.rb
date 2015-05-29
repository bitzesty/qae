require "countries"

module FormAnswerHelper
  def application_flags(fa)
    comments = fa.comments
    c_size = comments.select do |c|
      c.main_for?(current_subject) && c.flagged?
    end.size
    if c_size > 0 || importance_flag?(fa)
      content_tag :span, class: "icon-flagged" do
        content_tag :span, class: "flag-count" do
          c_size += 1 if importance_flag?(fa)
          c_size.to_s
        end
      end
    end
  end

  def importance_flag?(fa)
    fa.public_send("#{current_subject.class.to_s.downcase}_importance_flag?")
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

  def sic_code(form_answer)
    code = form_answer.sic_code
    code || "-"
  end

  def country_collection
    ([["United Kingdom", "GB"], ["United States", "US"]] + Country.all).uniq
  end

  def feedback_updated_by(form_answer)
    feedback = form_answer.feedback
    if feedback && feedback.authorable.present?
      "Updated by: #{feedback.authorable.decorate.full_name} - #{format_date(feedback.updated_at)}"
    end
  end

  def press_summary_updated_by(form_answer)
    ps = form_answer.press_summary
    if ps.present? && ps.authorable.present?
      "Updated by #{ps.authorable.decorate.full_name} - #{format_date(ps.updated_at)}"
    end
  end

  def assessors_collection_for_bulk
    assessors = Assessor.available_for(category_picker.current_award_type).map { |a| [a.full_name, a.id] }
    [["Not Assigned", "not assigned"]] + assessors
  end
end
