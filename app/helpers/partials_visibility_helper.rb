module PartialsVisibilityHelper
  def show_winners_section?(application)
    application.awarded? || application.recommended? || application.reserved?
  end

  def show_case_summary_section?(application)
    admin_lead_or_primary?(application)
  end

  def show_feedback_section?(application)
    !application.promotion? &&
      admin_lead_or_primary?(application)
  end

  def show_press_summary_subsection?(application)
    (application.awarded? || application.recommended? || application.reserved?) &&
      admin_lead_or_primary?(application)
  end

  def show_palace_attendees_subsection?(application)
    application.awarded? && admin_lead_or_primary?(application)
  end

  def show_bulk_assignment?
    current_subject.categories_as_lead.include?(category_picker.current_award_type)
  end

  def show_form_answer_attachment?(attachment)
    current_subject.is_a?(Admin) || !attachment.restricted_to_admin?
  end

  def show_remove_form_answer_attachment?(attachment)
    attachment.uploaded_not_by_user? && policy(attachment).destroy?
  end

  def show_shortlisted_document?(attachment)
    document = attachment&.shortlisted_documents_wrapper
    attachment.present? && policy(document).destroy?
  end

  private

  def admin_lead_or_primary?(application)
    current_subject.is_a?(Admin) ||
      current_subject.lead?(application) ||
      current_subject.primary?(application)
  end
end
