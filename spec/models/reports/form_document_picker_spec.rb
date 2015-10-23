require "rails_helper"

describe Reports::DataPickers::FormDocumentPicker do
  let(:dummy_class) do
    klass = Class.new do
      include Reports::DataPickers::FormDocumentPicker
    end
  end

  describe "#current_queens_award_holder" do
    let(:subject) { dummy_class.new }

    it "returns nil if no awards were entered" do
      allow(subject).to receive(:doc)
        .with("queen_award_holder_details").and_return(nil)
      expect(subject.current_queens_award_holder).to be_nil

      allow(subject).to receive(:doc)
        .with("queen_award_holder_details").and_return([])
      expect(subject.current_queens_award_holder).to be_nil
    end

    it "returns list of awards" do
      year_1, year_2 = PreviousWin.available_years
      awards = [
                {
                  "category" => "innovation",
                  "year" => year_1
                },
                {
                  "category" => "",
                  "year" => year_2
                }
      ]

      allow(subject).to receive(:doc)
        .with("queen_award_holder_details").and_return(awards)
      expected = "Innovation #{year_1}, #{year_2}"

      expect(subject.current_queens_award_holder).to eq(expected)
    end
  end
end
