require "rails_helper"

# checks if returns the csv without checking if data are correct

describe Reports::AdminReport do
  subject { described_class.new(id, AwardYear.current) }
  let(:form_answer) { FormAnswer.last }

  describe "#as_csv" do
    describe "registered users" do
      before { create_test_forms }

      let(:id) { "registered-users" }

      it "generates the CSV" do
        expect(subject.as_csv).to include("East Midlands")
      end
    end

    describe "press book list" do
      let(:press_summary) { create(:press_summary) }

      before do
        press_summary.form_answer.update!(state: "awarded")
      end

      let(:id) { "press-book-list" }
      it "generates the CSV" do
        expect(subject.as_csv).to include(press_summary.body)
      end
    end

    describe "cases status" do
      let(:id) { "cases-status" }
      before { create_test_forms }

      it "generates the CSV" do
        expect(subject.as_csv).to include(form_answer.urn)
      end
    end

    describe "entries report" do
      let(:id) { "entries-report" }
      before { create_test_forms }

      it "generates the CSV" do
        expect(subject.as_csv).to include(form_answer.urn)
      end
    end
  end
end

def create_test_forms
  create(:form_answer, :trade, :submitted)
  create(:form_answer, :innovation, :submitted)
  create(:form_answer, :promotion, :submitted)
end
