module AdminHelper
  def admin_conditional_pdf_link_target(form_answer, mode)
    if form_answer.hard_copy_ready_for?(mode) && !Rails.env.development?
      "_blank"
    else
      ""
    end
  end

  def admin_conditional_aggregated_pdf_link_target(award_year, mode)
    if award_year.aggregated_hard_copies_completed?(mode) && !Rails.env.development?
      "_blank"
    else
      ""
    end
  end
end
