require "rails_helper"

describe UsersImport::Builder do
  subject { described_class.new(Rails.root.join("spec/fixtures/users.csv")) }

  describe "#process" do
    it "imports the users" do
      subject.process
      row = User.where(email: "user1+import@example.com").first
      expect(row.first_name).to eq("First name1")
      expect(row.last_name).to eq("Last name1")
      expect(row.mobile_number).to eq("234324237")
      expect(row.created_at).to eq(Date.new(2014, 3, 21))
      expect(row.imported).to eq(true)
    end
    it "fails if save return false" do
      allow_any_instance_of(User).to receive(:save) { true }
      allow_any_instance_of(User).to receive(:save) { true }
      allow_any_instance_of(User).to receive(:save) { false }
      response = subject.process
      expect(response[:not_saved].size).to eq 2
    end
  end
end
