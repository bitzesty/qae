class FormAnswerStatus::AdminFilter
  extend FormAnswerStatus::FilteringHelper

  SUB_OPTIONS = {
    missing_sic_code: {
      label: "Missing SIC code",
    },
    assessors_not_assigned: {
      label: "Assessors not assigned",
    },
    primary_assessment_submitted: {
      label: "Primary Assessment submitted",
    },
    secondary_assessment_submitted: {
      label: "Secondary Assessment submitted",
    },
    primary_and_secondary_assessments_submitted: {
      label: "Primary and Secondary Assessments submitted",
    },
    primary_assessment_not_submitted: {
      label: "Primary Assessment not submitted",
    },
    secondary_assessment_not_submitted: {
      label: "Secondary Assessment not submitted",
    },
    recommendation_disperancy: {
      label: "Recommendation discrepancy",
    },
    missing_additional_finances: {
      label: "Missing additional financials",
    },
    additional_finances_not_reviewed: {
      label: "Additional financials - not reviewed yet",
    },
    missing_feedback: {
      label: "Missing Feedback",
    },
    missing_press_summary: {
      label: "Missing Press Summary",
      properties: {
        checked: "checked",
      },
    },
    missing_rsvp_details: {
      label: "Missing RSVP Details",
    },
  }

  OPTIONS = {
    eligibility_in_progress: {
      label: "Eligibility in progress",
      states: [:eligibility_in_progress],
    },
    application_in_progress: {
      label: "Application in progress",
      states: [:application_in_progress],
    },
    applications_not_submitted: {
      label: "Applications not submitted",
      states: [:not_submitted],
    },
    submitted: {
      label: "Application submitted",
      states: [:submitted],
    },
    assessment_in_progress: {
      label: "Assessment in progress",
      states: [:assessment_in_progress],
    },
    disqualified: {
      label: "Disqualified - no additional financials",
      states: [:disqualified],
    },
    recommended: {
      label: "Recommended",
      states: [
        :recommended,
      ],
    },
    reserve: {
      label: "Reserved",
      states: [
        :reserved,
      ],
    },
    not_recommended: {
      label: "Not recomended",
      states: [
        :not_recommended,
      ],
    },
    not_eligible: {
      label: "Not eligible",
      states: [
        :not_eligible,
      ],
    },
    withdrawn: {
      label: "Withdrawn/Ineligible",
      states: [
        :withdrawn,
      ],
    },
    awarded: {
      label: "Awarded",
      states: [
        :awarded,
      ],
    },
    not_awarded: {
      label: "Not Awarded",
      states: [
        :not_awarded,
      ],
    },
  }

  def self.options
    OPTIONS
  end

  def self.sub_options
    SUB_OPTIONS
  end
end
