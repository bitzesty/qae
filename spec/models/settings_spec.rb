require "rails_helper"

describe Settings do
  context "after create" do
    let(:settings) { Settings.current }
    let(:deadlines) {
      Deadline::AVAILABLE_DEADLINES.sort
    }

    it "creates all kinds of deadlines" do
      expect(settings.deadlines.count).to eq(13)
      expect(settings.deadlines.order(:kind).map(&:kind)).to eq(deadlines)
    end
  end

  describe "class methods & scopes " do
    it ".winner_notification_date should filter correctly" do
      target = Settings.current.winners_email_notification.try(:trigger_at).presence
      expect(target).to eq Settings.winner_notification_date
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

  describe ".current_award_year_switched?" do
    it "should return true if none of the awards are still open" do
      allow(Settings).to receive(:current_award_year_switch_date) { build(:deadline, trigger_at: 1.day.ago) }
      allow(Settings).to receive(:current_submission_start_deadlines) { [double(trigger_at: 1.day.from_now), double(trigger_at: nil)] }
      expect(Settings.current_award_year_switched?).to be_truthy
    end

    it "should return true if some of the awards are still closed" do
      allow(Settings).to receive(:current_award_year_switch_date) { build(:deadline, trigger_at: 2.days.ago) }
      allow(Settings).to receive(:current_submission_start_deadlines) { [double(trigger_at: 1.day.ago), double(trigger_at: nil)] }
      expect(Settings.current_award_year_switched?).to be_truthy
    end

    it "should return false if all of the awards are opened" do
      allow(Settings).to receive(:current_award_year_switch_date) { build(:deadline, trigger_at: 2.days.ago) }
      allow(Settings).to receive(:current_submission_start_deadlines) { [double(trigger_at: 1.day.ago), double(trigger_at: 1.day.ago)] }
      expect(Settings.current_award_year_switched?).to eq(false)
    end
  end
end
