class Reports::CaseIndexReport
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
      label: "CompanyName",
      method: :company_or_nominee_name
    },
    {
      label: "Overall status",
      method: :overall_status
    },
    {
      label: "SIC Code",
      method: :sic_code
    },
    {
      label: "Employees",
      method: :employees
    },
    {
      label: "CurrentQueensAwardHolder",
      method: :current_queens_award_holder
    },
    {
      label: "Verdict",
      method: :empty_column
    },
    {
      label: "Panel Comments",
      method: :empty_column
    },
    {
      label: "Feedback",
      method: :empty_column
    }
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
                      .order(:sic_code)
  end

  def mapping
    MAPPING
  end
end
