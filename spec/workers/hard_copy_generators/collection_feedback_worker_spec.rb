require "rails_helper"

RSpec.describe HardCopyPdfGenerators::Collection::FeedbackWorker do
  it "should perform correctly" do

    allow_any_instance_of(AwardYear).to receive(:feedback_generation_can_be_started?) {true}

    time = 6.hour.from_now
    allow_any_instance_of(ActiveSupport::Duration).to receive(:from_now).and_return(time)

    expect(HardCopyPdfGenerators::StatusCheckers::FeedbackWorker).to receive(:perform_at).with(time)
    described_class.new.perform
  end
end




