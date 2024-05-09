require "rails_helper"

RSpec.describe Supporter, type: :model do
  it "generates access key after creation" do
    expect(create(:supporter).access_key).to be
  end

  describe "Notify supporter" do
    let(:supporter) { create :supporter }
    subject { supporter }

    it "sends email delevery job to queue upon creation" do
      expect { supporter.send(:notify!) }.to change { MailDeliveryWorker.jobs.size }.by(1)
    end
  end
end
