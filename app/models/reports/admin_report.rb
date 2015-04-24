class Reports::AdminReport
  attr_reader :id, :year

  def initialize(id, year)
    @id = id
    @year = year
  end

  def build
    case id
    when "registered-users"
      Reports::RegisteredUsers.new(year).build
    when "press-book-list"
      Reports::PressBookList.new(year).build
    end
  end
end
