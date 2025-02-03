require "rails_helper"

describe Reports::CaseIndexReport do
  let(:year) { create(:award_year) }
  let(:category) { "innovation" }
  let(:years_mode) { "all" }
  let(:options) { { category: category, years_mode: years_mode } }
  let(:report) { described_class.new(year, options) }
  let(:expected_headers) { described_class::MAPPING.pluck(:label) }

  describe "#build" do
    let(:result) { report.build.split("\n") }

    context "when there are no form_answers" do
      it "only includes the headers" do
        expect(result.length).to eq(1)
        expected_headers.each { |h| expect(result.first).to include(h) }
      end
    end

    context "with form_answers that are not shortlisted" do
      let!(:form_answers) { create_list(:form_answer, 3, category.to_sym, award_year: year) }

      it "only includes the headers" do
        expect(result.length).to eq(1)
        expected_headers.each { |h| expect(result.first).to include(h) }
      end
    end

    context "with form_answers that do not match the category" do
      let!(:form_answers) { create_list(:form_answer, 3, :recommended, :trade, award_year: year) }

      it "only includes the headers" do
        expect(result.length).to eq(1)
        expected_headers.each { |h| expect(result.first).to include(h) }
      end
    end

    context "with form_answers that are shortlisted and match the category" do
      let!(:form_answers) { [form_answer_one, form_answer_two, form_answer_three] }

      let(:form_answer_one) { create(:form_answer, category.to_sym, :recommended, award_year: year) }
      let(:form_answer_two) { create(:form_answer, category.to_sym, :recommended, award_year: year) }
      let(:form_answer_three) { create(:form_answer, category.to_sym, :recommended, award_year: year) }

      before do
        form_answer_one.document["sic_code"] = "1984"
        form_answer_one.save!

        form_answer_two.document["sic_code"] = "0011"
        form_answer_two.save!

        form_answer_three.document["sic_code"] = "0030"
        form_answer_three.save!
      end

      it "includes the headers and the form_answers in the correct order" do
        expect(result.length).to eq(4)
        expected_headers.each { |h| expect(result.first).to include(h) }
        expect(result.second).to include(form_answer_two.urn)
        expect(result.third).to include(form_answer_three.urn)
        expect(result.fourth).to include(form_answer_one.urn)
      end
    end
  end

  describe "#stream" do
    let(:result) { report.stream.to_a }

    context "when there are no form_answers" do
      it "only includes the headers" do
        expect(result.length).to eq(1)
        expected_headers.each { |h| expect(result.first).to include(h) }
      end
    end

    context "with form_answers that are not shortlisted" do
      let!(:form_answers) { create_list(:form_answer, 3, category.to_sym, award_year: year) }

      it "only includes the headers" do
        expect(result.split("\n").length).to eq(1)
        expected_headers.each { |h| expect(result.first).to include(h) }
      end
    end

    context "with form_answers that do not match the category" do
      let!(:form_answers) { create_list(:form_answer, 3, :recommended, :trade, award_year: year) }

      it "only includes the headers" do
        expect(result.split("\n").length).to eq(1)
        expected_headers.each { |h| expect(result.first).to include(h) }
      end
    end

    context "with form_answers that are shortlisted and match the category" do
      let!(:form_answers) { [form_answer_one, form_answer_two, form_answer_three] }

      let(:form_answer_one) { create(:form_answer, category.to_sym, :recommended, award_year: year) }
      let(:form_answer_two) { create(:form_answer, category.to_sym, :recommended, award_year: year) }
      let(:form_answer_three) { create(:form_answer, category.to_sym, :recommended, award_year: year) }

      before do
        form_answer_one.document["sic_code"] = "1984"
        form_answer_one.save!

        form_answer_two.document["sic_code"] = "0011"
        form_answer_two.save!

        form_answer_three.document["sic_code"] = "0030"
        form_answer_three.save!
      end

      it "includes the headers and the form_answers in the correct order" do
        expect(result.length).to eq(4)
        expected_headers.each { |h| expect(result.first).to include(h) }
        expect(result.second).to include(form_answer_two.urn)
        expect(result.third).to include(form_answer_three.urn)
        expect(result.fourth).to include(form_answer_one.urn)
      end
    end
  end
end
