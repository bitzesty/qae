require "rails_helper"

describe Reports::Dashboard::ApplicationsReport do
  let!(:settings) { create(:settings, :submission_deadlines) }
  let(:deadline) { Settings.current_submission_deadline.trigger_at }
  let!(:application_1) { create(:form_answer, :trade, created_at: deadline - 3.months - 1.hour) }
  let!(:application_2) { create(:form_answer, :trade, :submitted, created_at: deadline - 2.months - 1.hour, submitted_at: deadline - 2.months - 1.hour) }
  let!(:application_3) { create(:form_answer, :trade, :submitted, created_at: deadline - 5.weeks - 1.hour, submitted_at: deadline - 4.weeks - 1.hour) }
  let!(:application_4) { create(:form_answer, :trade, :submitted, created_at: deadline - 4.weeks - 1.hour, submitted_at: deadline - 4.weeks - 1.hour) }
  let!(:application_5) { create(:form_answer, :trade, :submitted, created_at: deadline - 2.days - 1.hour, submitted_at: deadline - 1.day - 1.hour) }

  context "providing correct stats for the year" do
    it "calculates stats by month" do
      Timecop.freeze(deadline + 1.day) do
        year_stats = described_class.new(kind: "by_month").stats.first

        expect(year_stats.content).to eq([0, 0, 0, 0, 1, 0, 1, 1, 1, 3, 1, 4])
      end
    end

    it "calculates stats by week" do
      Timecop.freeze(deadline + 1.day) do
        year_stats = described_class.new(kind: "by_week").stats.first

        expect(year_stats.content).to eq([1, 1, 2, 1, 1, 3, 1, 3, 1, 3, 1, 3, 1, 4])
      end
    end

    it "calculates stats by day" do
      Timecop.freeze(deadline + 1.day) do
        year_stats = described_class.new(kind: "by_day").stats.first

        expect(year_stats.content).to eq([1, 3, 1, 3, 1, 3, 1, 3, 2, 3, 1, 4, 1, 4])
      end
    end
  end

  context "does not give an error without a deadline" do
    it "by month" do
      Timecop.freeze(deadline + 1.day) do
        Settings.current_submission_deadline.update_column(:trigger_at, nil)
        year_stats = described_class.new(kind: "by_month").stats.first

        expect(year_stats.content).to eq(["&nbsp;"] * 12)
      end
    end

    it "by week" do
      Timecop.freeze(deadline + 1.day) do
        Settings.current_submission_deadline.update_column(:trigger_at, nil)
        year_stats = described_class.new(kind: "by_week").stats.first

        expect(year_stats.content).to eq(["&nbsp;"] * 14)
      end
    end

    it "by day" do
      Timecop.freeze(deadline + 1.day) do
        Settings.current_submission_deadline.update_column(:trigger_at, nil)
        year_stats = described_class.new(kind: "by_day").stats.first

        expect(year_stats.content).to eq(["&nbsp;"] * 14)
      end
    end
  end
end
