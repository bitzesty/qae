module CaseSummaryHelper
  def visible_case_summaries(subject, form_answer)
    all = [
      wrap_case_summary(primary_case_summary_assessment, "Primary Case Summary"),
      wrap_case_summary(lead_case_summary_assessment)
    ]
    return all if subject.is_a?(Admin)

    primary = subject.primary?(form_answer)
    lead    = subject.lead?(form_answer)
    regular = subject.regular?(form_answer)

    assessments =
    if lead
      all
    elsif regular && primary
      [wrap_case_summary(primary_case_summary_assessment)]
    end

    assessments
  end

  def wrap_case_summary(summary, title = "Case Summary")
    OpenStruct.new(
      assessment: summary,
      title: title
    )
  end
end
