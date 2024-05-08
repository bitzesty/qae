require "rails_helper"

describe "CaseSummaryPdfs::Base" do
  let!(:award_year) do
    AwardYear.current
  end

  let!(:form_answer_current_year_innovation) do
    FactoryBot.create :form_answer, :recommended, :innovation, award_year: award_year
  end

  let!(:form_answer_current_year_trade) do
    FactoryBot.create :form_answer, :recommended, :trade, award_year: award_year
  end

  before do
    [:current_year].each do |year|
      [:innovation, :trade].each do |award_type|
        form_answer = send("form_answer_#{year}_#{award_type}")
        create :assessor_assignment, form_answer: form_answer,
          submitted_at: Date.today,
          assessor: nil,
          position: "case_summary",
          document: set_case_summary_content(form_answer)
      end
    end
  end

  describe "#set_form_answers" do
    it "should be ordered in year and filtered by category" do
      innovation_case_summaries = CaseSummaryPdfs::Base.new(
        "all", nil, {
          category: "innovation",
          award_year: award_year,
        }
      ).set_form_answers
       .map(&:id)

      expect(innovation_case_summaries).to match_array([
        form_answer_current_year_innovation.id,
      ])

      trade_case_summaries = CaseSummaryPdfs::Base.new(
        "all", nil, {
          category: "trade",
          award_year: award_year,
          years_mode: "3",
        }
      ).set_form_answers
       .map(&:id)

      expect(trade_case_summaries).to match_array([
        form_answer_current_year_trade.id,
      ])
    end
  end

  private

  def set_case_summary_content(form_answer)
    res = {}

    AppraisalForm.struct(form_answer).each do |key, value|
      res["#{key}_desc"] = "Lorem Ipsum"
      res["#{key}_rate"] = ["negative", "positive", "average"].sample
    end

    res
  end
end
