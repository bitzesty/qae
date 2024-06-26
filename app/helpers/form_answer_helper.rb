# frozen_string_literal: true

require "countries"

module FormAnswerHelper
  # This is a temporary method to disable Promoting Opportunity Award for users
  def display_social_mobility?
    ENV["DISPLAY_SOCIAL_MOBILITY_AWARD"] == "true"
  end

  def hide_promotion?
    !params[:year] || params[:year].to_i >= 2017
  end

  def application_flags(fa, subject = nil)
    comments_count = if subject
      if current_subject.is_a?(Admin)
        fa.flagged_admin_comments_count
      else
        fa.flagged_critical_comments_count
      end
    elsif current_subject.is_a?(Admin)
      fa.flagged_critical_comments_count
    else
      fa.flagged_admin_comments_count
    end

    current_user_class = current_subject.model_name.to_s.parameterize

    flag_type = if subject
      "icon-flag-#{current_user_class}"
    else
      (current_user_class == "admin") ? "icon-flag-assessor" : "icon-flag-admin"
    end

    if comments_count > 0
      tag.span(class: "icon-flagged #{flag_type}") do
        concat("#{current_user_class} flags: ")
        concat(tag.span(comments_count.to_s, class: "flag-count"))
      end
    end
  end

  def user_can_edit(form, item)
    policy(form).update_item?(item)
  end

  def user_can_edit_company(form)
    policy(form).update_company? && form.submitted_and_after_the_deadline?
  end

  def application_comments(comments_count)
    return unless comments_count > 0

    tag.span(class: "icon-comment") do
      concat("Comments: ")
      concat(tag.span(comments_count.to_s, class: "comment-count"))
    end
  end

  def award_types_collection(year)
    FormAnswer::AWARD_TYPE_FULL_NAMES.invert.select do |k, v|
      if year.present? && year.to_i <= 2016
        true
      else
        v != "promotion"
      end
    end.to_a
  end

  def each_index_or_empty(collection, attrs, &block)
    if collection.any?
      collection.each_with_index(&block)
    else
      yield(attrs, 0)
    end
  end

  def sic_code(form_answer)
    code = form_answer.sic_code
    code || "-"
  end

  def country_collection
    ([["United Kingdom of Great Britain and Northern Ireland", "GB"], ["United States of America", "US"]] +
     ISO3166::Country.all.map { |c| [c.name, c.alpha2] }).uniq
  end

  def assessors_collection_for_bulk
    assessors = Assessor.available_for(category_picker.current_award_type).map { |a| [a.full_name, a.id] }
    [["Not Assigned", "not assigned"]] + assessors
  end
end
