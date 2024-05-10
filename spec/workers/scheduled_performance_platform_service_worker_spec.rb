require "rails_helper"

RSpec.describe Scheduled::PerformancePlatformServiceWorker do
  it "should perform correctly" do
    expect(PerformancePlatformService).to receive(:run)
    described_class.new.perform
  end
end
