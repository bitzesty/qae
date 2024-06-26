require "rails_helper"

RSpec.describe HardCopyPdfGenerators::StatusCheckers::AggregatedFeedbackWorker do
  it "should perform correctly" do
    award_year = AwardYear.new
    allow(AwardYear).to receive(:current) { award_year }

    expect(award_year).to receive(:check_aggregated_hard_copy_pdf_generation_status!).with("feedback")
    described_class.new.perform
  end
end
