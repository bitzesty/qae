class Reports::CasesStatusReport
  include Reports::CSVHelper

  MAPPING = [
    {
      label: "URN",
      method: :urn
    },
    {
      label: "Category",
      method: :category
    },
    {
      label: "CompanyOrNominee",
      method: :company_or_nominee_name
    },
    {
      label: "FirstAssessor",
      method: :first_assessor
    },
    {
      label: "SecondAssessor",
      method: :second_assessor
    },
    {
      label: "CaseAssigned",
      method: :case_assigned
    },
    {
      label: "FirstAssessmentComplete",
      method: :first_assessment_complete
    },
    {
      label: "SecondAssessmentComplete",
      method: :second_assessment_complete
    },
    {
      label: "MSO_OutcomeAgreed",
      method: :mso_outcome_agreed
    },
    {
      label: "MSO_GradeAgreed",
      method: :mso_grade_agreed
    },
    {
      label: "CaseSummaryOverallGrade",
      method: :case_summary_overall_grade
    },
    {
      label: "PressReleaseUpdated",
      method: :press_release_updated
    },
    {
      label: "FinSumComplete",
      method: :fin_sum_complete
    },
    {
      label: "ACReceived",
      method: :ac_received
    },
    {
      label: "ACChecked",
      method: :ac_checked
    },
    {
      label: "FinSumReviewComplete",
      method: :fun_sum_review_complete
    },
    {
      label: "DCRChecked",
      method: :dcr_checked
    },
    {
      label: "CaseSummaryStatus",
      method: :case_summary_status
    },
    {
      label: "FeedbackComplete",
      method: :feedback_complete
    },
    {
      label: "CaseWithdrawn",
      method: :case_withdrawn
    },
    {
      label: "QAEOPermission",
      method: :qao_permission
    },
    {
      label: "SubCategory",
      method: :sub_category
    }
  ]

  def initialize(year)
    @scope = ::FormAnswer.all#where(award_year_id: year.id, submitted: true).includes(:user)
  end

  private

  def mapping
    MAPPING
  end
end
