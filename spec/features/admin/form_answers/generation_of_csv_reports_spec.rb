# extend to check the data more strictly - after reviewing by Client
require "rails_helper"

describe "Admin generates the CSV reports" do
  let!(:user) { create(:user, :completed_profile) }

  let!(:trade) { create(:form_answer, :trade, user: user, submitted_at: Time.current) }
  let!(:innovation) { create(:form_answer, :innovation, user: user) }
  let!(:development) { create(:form_answer, :development, user: user, state: "awarded") }
  let!(:mobility) { create(:form_answer, :mobility, user: user) }

  let(:output) do
    data = Reports::AdminReport.new(id, AwardYear.current).as_csv

    if data.is_a?(Enumerator)
      data.entries.map { |row| CSV.parse(row) }.flatten(1)
    else
      CSV.parse(data)
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
      expect(output[1][9]).to eq("No")
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
      expect(output[1][1]).to eq("Sustainable Development")
      expect(output[1][-6]).to eq("example.com")
    end
  end

  describe "Reception Buckingham Palace" do
    let(:id) { "reception-buckingham-palace" }

    let(:title) { "MyTitle" }
    let(:first_name) { "MyFirstName" }

    let!(:palace_invite) do
      create :palace_invite, form_answer: development,
        email: user.email,
        submitted: true
    end

    let!(:attendee) do
      create(:palace_attendee, palace_invite: palace_invite,
        title: title,
        first_name: first_name,)
    end

    it "produces proper output" do
      expect(output.size).to eq(2)
      expect(output[1][2]).to eq(title)
      expect(output[1][3]).to eq(first_name)
    end
  end
end
