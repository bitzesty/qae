class Reports::CasesStatusReport
  include Reports::CsvHelper

  MAPPING = [
    {
      label: "URN",
      method: :urn,
    },
    {
      label: "Category",
      method: :category,
    },
    {
      label: "CompanyOrNominee",
      method: :company_or_nominee_name,
    },
    {
      label: "SIC Code",
      method: :sic_code,
    },
    {
      label: "SIC code description",
      method: :sic_code_description,
    },
    {
      label: "Employees",
      method: :employees,
    },
    {
      label: "ProductService",
      method: :product_service,
    },
    {
      label: "FirstAssessor",
      method: :first_assessor,
    },
    {
      label: "SecondAssessor",
      method: :second_assessor,
    },
    {
      label: "CaseAssigned",
      method: :case_assigned,
    },
    {
      label: "FirstAssessmentComplete",
      method: :first_assessment_complete,
    },
    {
      label: "SecondAssessmentComplete",
      method: :second_assessment_complete,
    },
    {
      label: "MSO_OutcomeAgreed",
      method: :mso_outcome_agreed,
    },
    {
      label: "MSO_GradeAgreed",
      method: :mso_grade_agreed,
    },
    {
      label: "CaseSummaryOverallGrade",
      method: :case_summary_overall_grade,
    },
    {
      label: "Overall Status",
      method: :overall_status,
    },
    {
      label: "Additional Financials Received",
      method: :ac_received,
    },
    {
      label: "Additional Financials Checked",
      method: :ac_checked,
    },
    {
      label: "CaseSummaryStatus",
      method: :case_summary_status,
    },
    {
      label: "FeedbackComplete",
      method: :feedback_complete,
    },
    {
      label: "PressReleaseUpdated",
      method: :press_release_updated,
    },
    {
      label: "CaseWithdrawn",
      method: :case_withdrawn,
    },
    {
      label: "KAOPermission",
      method: :qao_permission,
    },
    {
      label: "SubCategory",
      method: :sub_category,
    },
  ]

  def initialize(year)
    @year = year
  end

  def build
    prepare_response(scoped_collection)
  end

  def build_for_lead(current_subject)
    scoped = scoped_collection.where(award_type: current_subject.categories_as_lead)

    prepare_response(scoped)
  end

  def stream
    prepare_stream(scoped_collection)
  end

  private

  def scoped_collection
    @year.form_answers.submitted
                      .order(:id)
                      .preload(:user,
                               :assessor_assignments,
                               :audit_certificate,
                               :feedback,
                               :primary_assessor,
                               :secondary_assessor)
  end

  def mapping
    MAPPING
  end
end
