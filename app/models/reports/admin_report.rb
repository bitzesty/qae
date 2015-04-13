class Reports::AdminReport
  def initialize(id, year)
    @id = id
    @year = year
  end

  def build
    # TODO: implement next reports (structures in /reports dir)
    Reports::RegisteredUsers.new(@year).build if @id == "registered-users"
  end
end
