class Reports::AdminReport
  ADMIN_REPORT = "admin_report"

  def initialize(id)
    @id = id
  end

  def build
    Reports::AdminReportBuilder.new.build if @id == ADMIN_REPORT
  end
end
