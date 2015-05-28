module PartialsVisibilityHelper
  def show_section_case_summary?
    return false unless moderated_assessment.submitted?
    return true if current_subject.lead?(@form_answer) || current_subject.primary?(@form_answer)
  end

  def show_section_appraisal_moderated?
    current_subject.lead?(@form_answer)
  end

  def show_winners_section?
    @form_answer.awarded? || @form_answer.recommended?
  end

  def show_feedback_section?
    @form_answer.unsuccessful? && !@form_answer.promotion? &&
      !current_subject.try(:secondary?, @form_answer)
  end

  def show_press_summary_subsection?
    (@form_answer.awarded? || @form_answer.recommended?) &&
      !current_subject.try(:secondary?, @form_answer)
  end

  def show_palace_attendees_subsection?
    @form_answer.awarded? && !current_subject.try(:secondary?, @form_answer)
  end

  def show_bulk_assignment?
    current_subject.categories_as_lead.include?(category_picker.current_award_type)
  end
end
