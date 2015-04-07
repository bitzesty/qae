require "countries"

module FormAnswerHelper
  def application_flags(fa)
    comments = fa.comments
    c_size = comments.select do |c|
      c.main_for?(current_subject) && c.flagged?
    end.size
    if c_size > 0
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

  def average_growth_for(form_answer, year)
    growth = form_answer.average_growth_for(year)
    growth || "-"
  end

  def sic_code(form_answer)
    code = form_answer.sic_code
    code || "-"
  end

  def country_collection
    ([["United Kingdom", "GB"], ["United States", "US"]] + Country.all).uniq
  end
end
