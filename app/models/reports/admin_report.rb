class Reports::AdminReport
  attr_reader :id, :year

  def initialize(id, year)
    @id = id
    @year = year
  end

require "ruby-prof"
  def build
    RubyProf.start
    out = case id
    when "registered-users"
      Reports::RegisteredUsers.new(year).build
    when "press-book-list"
      Reports::PressBookList.new(year).build
    when "cases-status"
      Reports::CasesStatusReport.new(year).build
    when "entries-report"
      Reports::AllEntries.new(year).build
    end
    result = RubyProf.stop

    printer = RubyProf::FlatPrinter.new(result)
    printer.print(STDOUT)
    out
  end
end
