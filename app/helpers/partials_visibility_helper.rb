module PartialsVisibilityHelper
  def show_section_case_summary?
    return false unless moderated_assessment.submitted?
    # show after submitting the appraisal forms

    if current_subject.lead?(@form_answer) &&
       current_subject.primary?(@form_answer)
      # Lead can be also the Primary Assessor - he sees it always
      return true
    end

    if primary_case_summary_assessment.submitted? &&
       (current_subject.lead?(@form_answer) || current_subject.primary?(@form_answer))
       # Both Lead/Primary see it when Primary has submitted his summary
      return true
    end

    if !primary_case_summary_assessment.submitted? &&
        current_subject.primary?(@form_answer)
        # If Primary has not submitted, he sees it only
      return true
    end
  end

  def show_section_appraisal_moderated?
    current_subject.lead?(@form_answer)
  end
end
