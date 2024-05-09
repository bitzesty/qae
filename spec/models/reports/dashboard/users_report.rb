require "rails_helper"

describe Reports::Dashboard::UsersReport do
  let!(:settings) { create(:settings, :submission_deadlines) }
  let(:deadline) { Settings.current_submission_deadline.trigger_at }
  let!(:user_1) { create(:user, created_at: deadline - 3.months - 1.hour) }
  let!(:user_2) { create(:user, created_at: deadline - 2.months - 1.hour) }
  let!(:user_3) { create(:user, created_at: deadline - 5.weeks - 1.hour) }
  let!(:user_4) { create(:user, created_at: deadline - 4.weeks - 1.hour) }
  let!(:user_5) { create(:user, created_at: deadline - 2.days - 1.hour) }

  context "providing correct stats for the year" do
    it "calculates stats by month" do
      Timecop.freeze(deadline + 1.day) do
        year_stats = described_class.new(kind: "by_month").stats.first

        expect(year_stats.content).to eq([0, 0, 1, 2, 4, 5])
      end
    end

    it "calculates stats by week" do
      Timecop.freeze(deadline + 1.day) do
        year_stats = described_class.new(kind: "by_week").stats.first

        expect(year_stats.content).to eq([2, 3, 4, 4, 4, 4, 5])
      end
    end

    it "calculates stats by day" do
      Timecop.freeze(deadline + 1.day) do
        year_stats = described_class.new(kind: "by_day").stats.first

        expect(year_stats.content).to eq([4, 4, 4, 4, 5, 5, 5])
      end
    end
  end

  context "does not give an error without a deadline" do
    it "by month" do
      Timecop.freeze(deadline + 1.day) do
        Settings.current_submission_deadline.update_column(:trigger_at, nil)
        year_stats = described_class.new(kind: "by_month").stats.first

        expect(year_stats.content).to eq(["&nbsp;"] * 6)
      end
    end

    it "by week" do
      Timecop.freeze(deadline + 1.day) do
        Settings.current_submission_deadline.update_column(:trigger_at, nil)
        year_stats = described_class.new(kind: "by_week").stats.first

        expect(year_stats.content).to eq(["&nbsp;"] * 7)
      end
    end

    it "by day" do
      Timecop.freeze(deadline + 1.day) do
        Settings.current_submission_deadline.update_column(:trigger_at, nil)
        year_stats = described_class.new(kind: "by_day").stats.first

        expect(year_stats.content).to eq(["&nbsp;"] * 7)
      end
    end
  end
end
