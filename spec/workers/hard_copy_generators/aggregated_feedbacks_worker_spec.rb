require "rails_helper"

RSpec.describe HardCopyPdfGenerators::Aggregated::FeedbacksWorker do
  it "should perform correctly" do
    allow_any_instance_of(AwardYear).to receive(:aggregated_feedback_generation_can_be_started?) {true}

    time = 1.hour.from_now
    allow_any_instance_of(ActiveSupport::Duration).to receive(:from_now).and_return(time)

    expect(HardCopyGenerators::AggregatedFeedbackGenerator).to receive(:run).with(AwardYear.current)
    expect(HardCopyPdfGenerators::StatusCheckers::AggregatedFeedbackWorker).to receive(:perform_at).with(time)
    described_class.new.perform
  end
end




