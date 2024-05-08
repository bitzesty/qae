require "rails_helper"

describe "FeedbackPdfs::Base" do
  let!(:award_year) do
    AwardYear.current
  end

  let!(:form_answer_innovation) do
    FactoryBot.create :form_answer, :submitted, :innovation
  end

  let!(:form_answer_trade) do
    FactoryBot.create :form_answer, :submitted, :trade
  end

  before do
    create :feedback, submitted: true,
                      form_answer: form_answer_trade,
                      document: set_feedback_content(form_answer_trade)

    create :feedback, submitted: true,
                      form_answer: form_answer_innovation,
                      document: set_feedback_content(form_answer_innovation)
  end

  describe "#set_feedbacks" do
    it "should be ordered in year and filtered by category" do
      innovation_feedbacks = FeedbackPdfs::Base.new(
        "all", nil, {
          category: "innovation",
          award_year: award_year
        }
      ).set_feedbacks
       .map(&:id)

      expect(innovation_feedbacks).to match_array([
        form_answer_innovation.feedback.id,
      ])

      trade_feedbacks = FeedbackPdfs::Base.new(
        "all", nil, {
          category: "trade",
          award_year: award_year
        }
      ).set_feedbacks
       .map(&:id)

      expect(trade_feedbacks).to match_array([
        form_answer_trade.feedback.id,
      ])
    end
  end

  private

  def set_feedback_content(form_answer)
    res = {}

    FeedbackForm.fields_for_award_type(form_answer).each_with_index do |block, index|
      key = block[0]
      res["#{key}_strength"] = "#{index}_strength"
      res["#{key}_weakness"] = "#{index}_weakness"
    end

    res
  end
end
