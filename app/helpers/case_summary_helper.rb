module CaseSummaryHelper
  def visible_case_summaries(subject, form_answer)
    all = [
      wrap_case_summary(case_summary_assessment),
    ]
    return all if subject.is_a?(Admin)

    lead = subject.lead?(form_answer)
    primary = subject.primary?(form_answer)

    (all if lead || primary)
  end

  def wrap_case_summary(summary, title = "Case Summary")
    OpenStruct.new(
      assessment: summary,
      title: title,
    )
  end

  def submit_case_summary_title(assessment)
    prefix = policy(assessment).can_be_submitted? ? "Confirm" : "Re-submit"
    "#{prefix} Case Summary"
  end
end
