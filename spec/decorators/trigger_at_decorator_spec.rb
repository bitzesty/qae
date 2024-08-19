require "rails_helper"

describe TriggerAtDecorator do
  let(:date) { DateTime.new(2015, 2, 6, 8, 30) }

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

  describe "#formatted_trigger_time_short" do
    context "without a trigger_at value" do
      it "returns a placeholder value" do
        deadline = build_stubbed(:deadline, trigger_at: nil).decorate
        expect(deadline.formatted_trigger_time_short).to eq("<strong>-- --- #{AwardYear.current.year}</strong> at --:--")
      end
    end

    context "with a trigger_at value" do
      it "returns the trigger_at value formatted" do
        deadline = build_stubbed(:deadline, trigger_at: date).decorate
        expect(deadline.formatted_trigger_time_short).to eq(deadline.trigger_at.strftime("%d/%m/%Y"))
      end
    end
  end

  describe "#formatted_trigger_date" do
    context "without a trigger_at value" do
      it "returns a date placeholder value" do
        deadline = build_stubbed(:deadline, trigger_at: nil).decorate
        expect(deadline.formatted_trigger_date).to eq("<strong>-- --- #{AwardYear.current.year}</strong>")
      end
    end

    context "without a format param" do
      it "returns the default format for date" do
        deadline = build_stubbed(:deadline, trigger_at: date).decorate
        expect(deadline.formatted_trigger_date).to eq(deadline.trigger_at.strftime("#{deadline.trigger_at.day.ordinalize} %B"))
      end
    end

    context "with a trigger_at value and a format param value" do
      it "returns the trigger_at value formatted with year" do
        deadline = build_stubbed(:deadline, trigger_at: date).decorate
        expect(deadline.formatted_trigger_date("with_year")).to eq(deadline.trigger_at.strftime(deadline.trigger_at.strftime("#{deadline.trigger_at.day.ordinalize} %B %Y")))
      end
    end
  end
end
