require "rails_helper"

describe TriggerAtDecorator do

  let(:date) { DateTime.new(2015,2,6,8,30) }

  before do
    award_year = instance_double("AwardYear", year: 2018, settings: nil)
    allow(AwardYear).to receive(:current).and_return(award_year)
  end

  describe "#formatted_trigger_time" do
    it "Returns a placeholder if trigger_at is nil" do
      deadline = build_stubbed(:deadline, trigger_at: nil).decorate
      expect(deadline.formatted_trigger_time).to eq("<strong>-- --- 2018</strong> at --:--")
    end

    it "Returns expected format" do
      deadline = build_stubbed(:deadline, trigger_at: date).decorate
      expect(deadline.formatted_trigger_time).to eq("<strong>6 Feb 2015</strong> at 8:30am")
    end

    it "Returns midnight if time is 00:00" do
      deadline = build_stubbed(:deadline, trigger_at: date.midnight).decorate
      expect(deadline.formatted_trigger_time).to eq("<strong>6 Feb 2015</strong> at midnight")
    end

    it "Returns midday if time is 12:00" do
      deadline = build_stubbed(:deadline, trigger_at: date.midday).decorate
      expect(deadline.formatted_trigger_time).to eq("<strong>6 Feb 2015</strong> at midday")
    end
  end
end
