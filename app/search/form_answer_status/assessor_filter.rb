class FormAnswerStatus::AssessorFilter
  # TODO: clarify if we need to extract separated filter for primary/secondary, as they should
  # see for example 'assessors not assigned option'
  extend FormAnswerStatus::FilteringHelper

  OPTIONS = {
    application_in_progress: {
      label: "Application in progress",
      states: [:application_in_progress]
    },
    assessment_in_progress: {
      label: "Assessment in progress",
      states: [:assessment_in_progress]
    },
    recommended: {
      label: "Recommended",
      states: [:recommended]
    },
    not_recommended: {
      label: "Not Recommended",
      states: [:not_recommended]
    },
    reserved: {
      label: "Reserved",
      states: [:reserved]
    },
    not_eligible: {
      label: "Not Eligible",
      states: [:not_eligible]
    },
    withdrawn: {
      label: "Withdrawn",
      states: [:withdrawn]
    },
    submitted: {
      label: "Submitted",
      states: [:submitted]
    },
    not_submitted: {
      label: "Not submitted",
      states: [:not_submitted]
    }
  }

  SUB_OPTIONS = {
    missing_sic_code: {
      label: "Missing SIC code"
    },
    assessors_not_assigned: {
      label: "Assessors not assigned"
    },
    missing_audit_certificate: {
      label: "Missing Audit Certificate (not impl)"
    },
    missing_feedback: {
      label: "Missing Feedback (not imple)"
    },
    missing_press_summary: {
      label: "Missing Press Summary (not impl)"
    }
  }

  def self.options
    OPTIONS
  end

  def self.sub_options
    SUB_OPTIONS
  end
end
