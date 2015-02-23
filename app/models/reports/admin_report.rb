class Reports::AdminReport
  ADMIN_REPORT3 = "admin_report3"

  def initialize(id)
    @id = id
  end

  def build
    if @id == ADMIN_REPORT3
      Reports::AdminReportBuilder.new.build
    end
  end
end
