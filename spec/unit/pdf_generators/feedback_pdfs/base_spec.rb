require 'rails_helper'

describe "FeedbackPdfs::Base" do
  let!(:form_answer_2014_innovation) do
    FactoryGirl.create :form_answer, :submitted, :innovation,
                        award_year: 2014
  end

  let!(:form_answer_2015_innovation) do
    FactoryGirl.create :form_answer, :submitted, :innovation,
                        award_year: 2015
  end

  let!(:form_answer_2014_trade) do
    FactoryGirl.create :form_answer, :submitted, :trade,
                        award_year: 2014
  end

  let!(:form_answer_2015_trade) do
    FactoryGirl.create :form_answer, :submitted, :trade,
                        award_year: 2015
  end

  before do
    create :feedback, submitted: true,
                      form_answer: form_answer_2014_trade,
                      document: set_feedback_content(:trade)

    create :feedback, submitted: true,
                      form_answer: form_answer_2015_trade,
                      document: set_feedback_content(:trade)

    create :feedback, submitted: true,
                      form_answer: form_answer_2015_innovation,
                      document: set_feedback_content(:innovation)

    create :feedback, submitted: true,
                      form_answer: form_answer_2014_innovation,
                      document: set_feedback_content(:innovation)
  end

  describe "#set_feedbacks" do
    it "should be ordered in year and filtered by category" do
      innovation_feedbacks = FeedbackPdfs::Base.new("all", nil, {category: "innovation"})
                                               .set_feedbacks
                                               .map(&:id)

      expect(innovation_feedbacks).to match_array([
        form_answer_2014_innovation.feedback.id,
        form_answer_2015_innovation.feedback.id
      ])

      trade_feedbacks = FeedbackPdfs::Base.new("all", nil, {category: "trade"})
                                          .set_feedbacks
                                          .map(&:id)

      expect(trade_feedbacks).to match_array([
        form_answer_2014_trade.feedback.id,
        form_answer_2015_trade.feedback.id
      ])
    end
  end

  private

  def set_feedback_content(award_type)
    res = {}

    FeedbackForm.fields_for_award_type(award_type).each_with_index do |block, index|
      key = block[0]
      res["#{key}_strength"] = "#{index}_strength"
      res["#{key}_weakness"] = "#{index}_weakness"
    end

    res
  end
end
