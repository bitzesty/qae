# On the day then Final Stage - Winners notifications are sent,
# generates a hard copy of the Aggregated Case Summary PDF for all FormAnswers together
# which have it

# Use:
# HardCopyGenerators::AggregatedCaseSummaryGenerator.new.run
#

class HardCopyGenerators::AggregatedCaseSummaryGenerator < HardCopyGenerators::AggregatedBase
  class << self
    def run(award_year)
      AwardYear::CURRENT_YEAR_AWARDS.each do |award_category|
        new(award_category, award_year, "case_summary").run
      end
    end
  end

  def set_pdf!
    @pdf = CaseSummaryPdfs::Base.new(
      "all", nil, category: award_category, award_year: award_year
    )
  end
end
