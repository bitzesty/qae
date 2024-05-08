require "rails_helper"
require "models/shared/formatted_time_for_examples"

RSpec.describe EmailNotification do
  describe "#trigger_at" do
    include_examples "date_time_for", :trigger_at
  end

  describe "scopes & class methods" do
    it ".not_shortlisted should filter correctly" do
      target = EmailNotification.where(kind: "not_shortlisted_notifier").to_sql
      expect(target).to eq EmailNotification.not_shortlisted.to_sql
    end

    it ".not_awarded should filter correctly" do
      target =  EmailNotification.where(kind: ["unsuccessful_notification", "unsuccessful_ep_notification"]).to_sql
      expect(target).to eq EmailNotification.not_awarded.to_sql
    end
  end

  describe "#passed?" do
    it "should return true" do
      expect(build(:email_notification, trigger_at: 1.minute.ago).passed?).to be_truthy
    end
    it "should return false" do
      expect(build(:email_notification, trigger_at: 1.minute.from_now).passed?).to be_falsey
    end
  end
end
