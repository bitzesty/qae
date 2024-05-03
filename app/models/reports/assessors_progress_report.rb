class Reports::AssessorsProgressReport
  include Reports::CsvHelper

  CSV_HEADERS = [
    "Assessor ID",
    "Assessor Name",
    "Assessor Email",
    "Primary Assigned",
    "Primary Assessed",
    "Primary Case Summary",
    "Primary Feedback",
    "Secondary Assigned",
    "Secondary Assessed",
    "Total Assigned",
    "Total Assessed",
  ]

  attr_accessor :year,
                :award_category

  def initialize(year, award_category)
    self.year = year
    self.award_category = award_category
  end

  def build
    data = Reports::DataPickers::AssessorProgressPicker.new(
      year,
      award_category,
    ).results

    CSV.generate(encoding: "UTF-8", force_quotes: true) do |csv|
      csv << CSV_HEADERS

      data.each do |row|
        csv << row
      end
    end
  end
end
