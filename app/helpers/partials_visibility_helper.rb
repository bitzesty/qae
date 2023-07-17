module PartialsVisibilityHelper
  def show_section_case_summary?
    return false unless moderated_assessment.submitted?
    return true if current_subject.lead?(@form_answer) || current_subject.primary?(@form_answer)
  end

  def show_section_appraisal_moderated?
    policy(@form_answer).show_section_appraisal_moderated?
  end

  def show_winners_section?
    @form_answer.awarded? || @form_answer.recommended? || @form_answer.reserved?
  end

  def show_case_summary_section?
    admin_lead_or_primary?
  end

  def show_feedback_section?
    !@form_answer.promotion? &&
      admin_lead_or_primary?
  end

  def show_press_summary_subsection?
    (@form_answer.awarded? || @form_answer.recommended? || @form_answer.reserved?) &&
      admin_lead_or_primary?
  end

  def show_palace_attendees_subsection?
    @form_answer.awarded? && admin_lead_or_primary?
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

  def admin_lead_or_primary?
    current_subject.is_a?(Admin) ||
    current_subject.lead?(@form_answer) ||
    current_subject.primary?(@form_answer)
  end
end
