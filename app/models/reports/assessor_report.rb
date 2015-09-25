class Reports::AssessorReport
  attr_reader :id, :year, :params

  def initialize(id, year, current_subject, params = {})
    @id = id
    @year = year
    @params = params
    @current_subject = current_subject
  end

  def as_csv
    case id
    when "cases-status"
      Reports::CasesStatusReport.new(year).build_for_lead(@current_subject)
    end
  end
end
