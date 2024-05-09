require "rails_helper"

RSpec.describe Scheduled::EmailNotificationServiceWorker do
  it "should perform correctly" do
    expect(Notifiers::EmailNotificationService).to receive(:run)
    described_class.new.perform
  end
end
