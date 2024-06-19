require "rails_helper"

RSpec.describe HardCopyPdfGenerators::Collection::FormDataWorker do
  it "should perform correctly" do
    allow_any_instance_of(AwardYear).to receive(:form_data_generation_can_be_started?) { true }

    time = 6.hours.from_now
    allow_any_instance_of(ActiveSupport::Duration).to receive(:from_now).and_return(time)

    expect(HardCopyPdfGenerators::StatusCheckers::FormDataWorker).to receive(:perform_at).with(time)
    described_class.new.perform
  end
end
