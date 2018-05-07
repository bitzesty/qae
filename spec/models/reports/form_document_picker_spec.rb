require "rails_helper"

describe Reports::DataPickers::FormDocumentPicker do
  let(:dummy_class) do
    klass = Class.new do
      include Reports::DataPickers::FormDocumentPicker

      def obj; end
    end
  end

  describe "#current_queens_award_holder" do
    let(:subject) { dummy_class.new }

    it "returns nil if no awards were entered" do
      expect(subject).to receive(:obj).and_return(double(previous_wins: nil))
      expect(subject.current_queens_award_holder).to be_nil

      allow(subject).to receive(:obj).and_return(double(previous_wins: []))
      expect(subject.current_queens_award_holder).to be_nil
    end

    it "returns list of awards" do
      year_1, year_2, year_3 = PreviousWin.available_years
      awards = [
                {
                  "category" => "innovation",
                  "year" => year_1,
                  "outcome" => "won"
                },
                {
                  "category" => "",
                  "year" => year_2,
                  "outcome" => "won"
                },
                {
                  "category" => "trade",
                  "year" => year_3,
                  "outcome" => "did_not_win"
                }
      ]

      allow(subject).to receive(:obj).and_return(double(previous_wins: awards))
      expected = "Innovation #{year_1}, #{year_2}"

      expect(subject.current_queens_award_holder).to eq(expected)
    end
  end
end
