class FormAnswerStatus::AssessorFilter
  extend FormAnswerStatus::FilteringHelper

  OPTIONS = {
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
    }
  }

  SUB_OPTIONS = {
    missing_sic_code: {
      label: "Missing SIC code (not impl)"
    },
    assessors_not_assigned: {
      label: "Assessors not assigned (not imple)"
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
