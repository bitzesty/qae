# On the day then Final Stage - Winners notifications are sent,
# generates a hard copy of the Aggregated Case Summary PDF for all FormAnswers together
# which have it

# Use:
# HardCopyGenerators::AggregatedCaseSummaryGenerator.new.run
#

class HardCopyGenerators::AggregatedCaseSummaryGenerator < HardCopyGenerators::AggregatedBase

  attr_accessor :sub_type

  def initialize(award_category, award_year, type_of_report, sub_type=nil)
    @timestamp = Time.zone.now.strftime("%d_%b_%Y_%H_%M")
    @award_category = award_category
    @award_year = award_year
    @type_of_report = type_of_report
    @sub_type = sub_type || "standart"

    set_pdf!
  end

  private

  def attach_generated_file!
    pdf_record = award_year.send("aggregated_#{type_of_report}_hard_copies").new(
      file: tmpfile,
      type_of_report: type_of_report,
      sub_type: sub_type,
      award_category: award_category,
      original_filename: "#{file_prefix}.pdf"
    )

    pdf_record.save!
  end

  class << self
    def run(award_year)
      AwardYear::CURRENT_YEAR_AWARDS.each do |award_category|
        if award_category == "trade"
          new(award_category, award_year, "case_summary", 3).run
          new(award_category, award_year, "case_summary", 6).run
        else
          new(award_category, award_year, "case_summary").run
        end
      end
    end
  end

  def set_pdf!
    ops = {category: award_category, award_year: award_year}
    ops[:years_mode] = sub_type if award_category == "trade"

    @pdf = CaseSummaryPdfs::Base.new(
      "all", nil, ops
    )
  end
end
