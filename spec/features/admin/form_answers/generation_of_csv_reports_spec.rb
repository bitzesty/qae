# extend to check the data more strictly - after reviewing by Client
require "rails_helper"

describe "Admin generates the CSV reports" do
  let!(:user) { create(:user, :completed_profile) }

  let!(:trade) { build(:form_answer, :trade, user: user, submitted: true) }
  let!(:innovation) { build(:form_answer, :innovation, user: user) }
  let!(:development) { build(:form_answer, :development, user: user, state: "awarded") }
  let!(:promotion) { build(:form_answer, :promotion, user: user) }

  let(:output) do
    csv = Reports::AdminReport.new(id, AwardYear.current).as_csv
    CSV.parse(csv)
  end

  before do
    [trade, innovation, development].each do |fa|
      document = fa.document
      document["applying_for"] = "division branch subsidiary"
      fa.document = document

      fa.save!
    end
  end

  describe "Registered users entry" do
    let(:id) { "registered-users" }
    it "produces proper output" do
      expect(output.size).to eq(FormAnswer.count + 1)
      expect(output[1][8]).to eq("Test Company")
      expect(output[1][9]).to eq("trade")
    end
  end

  describe "Cases status" do
    let(:id) { "cases-status" }
    it "produces proper output" do
      expect(output.size).to eq(2)
      expect(output[1][7]).to eq("No")
      expect(output[1][-1]).to eq("Outstanding growth in the last 3 years")
    end
  end

  describe "Entries report" do
    let(:id) { "entries-report" }
    it "produces proper output" do
      expect(output.size).to eq(FormAnswer.count + 1)
      expect(output[1][1]).to eq("International Trade")
      expect(output[1][9]).to eq("Director")
    end
  end

  describe "Press book list" do
    let(:id) { "press-book-list" }
    it "produces proper output" do
      expect(output.size).to eq(2)
      expect(output[1][-2]).to eq("GB")
      expect(output[1][-4]).to eq("example.com")
    end
  end
end
