# On the day then Final Stage - Winners notifications are sent,
# generates a hard copy of the Aggregated Feedback PDF for all FormAnswers together
# which have it

# Use:
# HardCopyGenerators::AggregatedFeedbackGenerator.new.run
#

class HardCopyGenerators::AggregatedFeedbackGenerator < HardCopyGenerators::AggregatedBase
  class << self
    def run(award_year)
      AwardYear::CURRENT_YEAR_AWARDS.each do |award_category|
        new(award_category, award_year, "feedback").run
      end
    end
  end

  def set_pdf!
    @pdf = FeedbackPdfs::Base.new(
      "all", nil, category: award_category, award_year:
    )
  end
end
