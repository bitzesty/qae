class FormAnswerStatus::AdminFilter
  extend FormAnswerStatus::FilteringHelper

  SUB_OPTIONS = {
    missing_sic_code: {
      label: "Missing SIC code"
    },
    assessors_not_assigned: {
      label: "Assessors not assigned"
    },
    missing_audit_certificate: {
      label: "Missing Audit Certificate"
    },
    missing_corp_responsibility: {
      label: "Missing Corp Responsibility (not impl.)"
    },

    missing_feedback: {
      label: "Missing Feedback"
    },

    missing_press_summary: {
      label: "Missing Press Summary",
      properties: {
        checked: "checked"
      }
    },
    missing_rsvp_details: {
      label: "Missing RSVP Details (not impl.)"
    }
  }

  OPTIONS = {
    application_in_progress: {
      label: "Application in progress",
      states: [:application_in_progress]
    },
    applications_not_submitted: {
      label: "Applications not submitted",
      states: [:not_submitted]
    },
    submitted: {
      label: "Application submitted",
      states: [:submitted]
    },
    assessment_in_progress: {
      label: "Assessment in progress",
      states: [:assessment_in_progress]
    },
    recommended: {
      label: "Recommended",
      states: [
        :recommended
      ]
    },
    reserve: {
      label: "Reserved",
      states: [
        :reserved
      ]
    },
    not_recommended: {
      label: "Not recomended",
      states: [
        :not_recommended
      ]
    },
    not_eligible: {
      label: "Not eligible",
      states: [
        :not_eligible
      ]
    },
    withdrawn: {
      label: "Withdrawn",
      states: [
        :withdrawn
      ]
    }
  }

  def self.options
    OPTIONS
  end

  def self.sub_options
    SUB_OPTIONS
  end
end
