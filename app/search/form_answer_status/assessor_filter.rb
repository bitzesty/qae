class FormAnswerStatus::AssessorFilter
  extend FormAnswerStatus::FilteringHelper

  OPTIONS = {
    eligibility_in_progress: {
      label: "Eligibility in progress",
      states: [:eligibility_in_progress]
    },
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
    withdrawn: {
      label: "Withdrawn",
      states: [:withdrawn]
    },
    submitted: {
      label: "Submitted",
      states: [:submitted]
    },
    awarded: {
      label: "Awarded",
      states: [:awarded]
    },
    not_awarded: {
      label: "Not Awarded",
      states: [:not_awarded]
    }
  }

  SUB_OPTIONS = {
    missing_sic_code: {
      label: "Missing SIC code"
    },
    assessors_not_assigned: {
      label: "Assessors not assigned"
    },
    primary_assessment_submitted: {
      label: "Primary Assessment submitted"
    },
    secondary_assessment_submitted: {
      label: "Secondary Assessment submitted"
    },
    missing_audit_certificate: {
      label: "Missing Audit Certificate"
    },
    audit_certificate_not_reviewed: {
      label: "Audit Certificate - not reviewed yet"
    },
    missing_corp_responsibility: {
      label: "Missing Corp Responsibility"
    },
    missing_feedback: {
      label: "Missing Feedback"
    },
    missing_press_summary: {
      label: "Missing Press Summary"
    }
  }

  def self.checked_options
    OPTIONS.except(:eligibility_in_progress, :application_in_progress)
  end

  def self.options
    OPTIONS
  end

  def self.sub_options
    SUB_OPTIONS
  end
end
