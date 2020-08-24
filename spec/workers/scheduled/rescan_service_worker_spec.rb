require "rails_helper"

describe Scheduled::RescanServiceWorker do
  it "should trigger rescan service" do
    expect(RescanService).to receive(:perform)
    described_class.new.perform
  end
end
