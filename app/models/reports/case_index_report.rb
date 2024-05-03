class Reports::CaseIndexReport
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
      label: "CompanyName",
      method: :company_or_nominee_name,
    },
    {
      label: "Overall status",
      method: :overall_status,
    },
    {
      label: "SIC Code",
      method: :sic_code,
    },
    {
      label: "Employees",
      method: :employees,
    },
    {
      label: "CurrentQueensAwardHolder",
      method: :current_queens_award_holder,
    },
    {
      label: "Verdict",
      method: :empty_column,
    },
    {
      label: "Panel Comments",
      method: :empty_column,
    },
    {
      label: "Feedback",
      method: :empty_column,
    },
  ]

  def initialize(year, options = {})
    @year = year
    @category = options[:category]
    @years_mode = options[:years_mode]
  end

  def build
    prepare_response(scoped_collection)
  end

  def stream
    prepare_stream(scoped_collection)
  end

  private

  def scoped_collection
    scope = @year.form_answers
      .shortlisted
      .where(award_type: @category)
      .order(:sic_code)

    if @category == "trade"
      years_mode_query = @years_mode.to_s == "3" ? "3 to 5" : "6 plus"

      scope = scope.where("form_answers.document #>> '{trade_commercial_success}' = '#{years_mode_query}'")
    end

    scope
  end

  def mapping
    MAPPING
  end
end
