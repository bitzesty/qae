class FormAnswerStatus::ForAssessorFilter
  OPTIONS = [
    {
      section: {
        label: "Pre-Assessment"
      },
      options: {
        missing_sic_code: {
          label: "Missing SIC code"
        },
        assessors_not_assigned: {
          label: "Assessors not assigned"
        },
        assessment_in_progress: {
          label: "Assessment in Progress"
        }
      }
    },

    {
      section: {
        label: "Pending Approval"
      },

      options: {
        recommended_pending: {
          label: "Recommended - Pending Approval"
        },
        reserve_pending: {
          label: "Reserve - Pending Approval"
        },
        not_recommended: {
          label: "Not Recommended - Pending Approval"
        },
        undecided: {
          label: "Undecided - Pending Approval"
        }
      }
    },

    {
      section: {
        label: "Approved"
      },

      options: {
        recommended_approved: {
          label: "Recommended - Approved"
        },
        reserve_approved: {
          label: "Reserve - Approved"
        },
        not_recommended_approved: {
          label: "Not Recommended - Approved"
        },
        not_eligible: {
          label: "Not Eligible"
        },
        withdrawn: {
          label: "Withdrawn"
        }
      }
    }
  ]

  def self.collection
    OPTIONS
  end
end
