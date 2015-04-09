require "rails_helper"

describe FormAnswerStatistics::Picker do
  subject { described_class.new }

  describe "#applications_submissions" do
    it "calculates proper stats" do
      create(:form_answer, :trade)
      fa1 = create(:form_answer, :trade)
      fa1.state_machine.perform_transition(:submitted)

      Timecop.freeze(Date.today - 3.days) do
        fa2 = create(:form_answer, :trade)
        fa2.state_machine.perform_transition(:submitted)
      end

      Timecop.freeze(Date.today - 8.days) do
        fa3 = create(:form_answer, :trade)
        fa3.state_machine.perform_transition(:submitted)
      end

      expect(subject.applications_submissions["trade"]).to eq([1, 2, 3])
    end

    context "multiple submissions" do
      it "counts the submitted records only once" do
        Timecop.freeze(Date.today - 4.days) do
          fa1 = create(:form_answer, :trade)
          fa1.state_machine.perform_transition(:submitted)
          fa1.state_machine.perform_transition(:submitted)
        end
        expect(subject.applications_submissions["trade"]).to eq([0, 1, 1])
      end
    end
  end

  describe "#applications_completions" do
    it "calculates proper stats" do
      create(:form_answer, :trade).update_column(:fill_progress, 0.0)
      create(:form_answer, :trade).update_column(:fill_progress, 0.25)
      create(:form_answer, :trade).update_column(:fill_progress, 0.50)
      create(:form_answer, :trade).update_column(:fill_progress, 1)
      create(:form_answer, :trade, state: "not_eligible").update_column(:fill_progress, 0.99)
      expect(subject.applications_completions["trade"]).to eq([1, 1, 0, 1, 1, 0, 1, 5])
    end
  end
end
