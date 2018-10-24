require "rails_helper"

describe Settings do
  context "after create" do
    let(:settings) {Settings.current}
    let(:deadlines) {
      Deadline::AVAILABLE_DEADLINES.sort do |a, b|
        a <=> b
      end
    }

    it "creates all kinds of deadlines" do
      expect(settings.deadlines.count).to eq(9)
      expect(settings.deadlines.order(:kind).map(&:kind)).to eq(deadlines)
    end
  end

  describe 'class methods & scopes ' do
    it ".winner_notification_date should filter correctly" do
      target = Settings.current.winners_email_notification.try(:trigger_at).presence
      expect(target).to eq Settings.winner_notification_date
    end

    it ".current_registrations_open_on? should return true" do
      allow(Settings).to receive(:current_registrations_open_on_date) {build(:deadline, trigger_at: 1.day.ago)}
      allow(Settings).to receive(:current_submission_start_deadline) {build(:deadline, trigger_at: 1.day.from_now)}
      expect(Settings.current_registrations_open_on?).to be_truthy
    end

    it ".not_shortlisted_deadline should filter correctly" do
      target = Settings.current.email_notifications.not_shortlisted.first.try(:trigger_at)
      expect(target).to eq Settings.not_shortlisted_deadline
    end

    it ".not_awarded_deadline should filter correctly" do
      target = Settings.current.email_notifications.not_awarded.first.try(:trigger_at)
      expect(target).to eq Settings.not_awarded_deadline
    end
  end
end
