module PartialsVisibilityHelper
  def show_section_case_summary?
    moderated_assessment.submitted? &&
      (primary_case_summary_assessment.submitted? &&
        current_subject.lead?(@form_answer) ||
      (current_subject.primary?(@form_answer)))
  end

  def show_section_appraisal_moderated?
    current_subject.lead?(@form_answer)
  end
end
