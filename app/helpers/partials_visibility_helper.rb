module PartialsVisibilityHelper
  def show_section_case_summary?
    return false unless moderated_assessment.submitted?
    return true if current_subject.lead?(@form_answer) || current_subject.primary?(@form_answer)
  end

  def show_section_appraisal_moderated?
    current_subject.lead?(@form_answer)
  end
end
