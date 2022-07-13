require "rails_helper"

describe PalaceAttendee do
  context "validation" do
    let(:attendee) { build(:palace_attendee) }

    it "validates required fields" do
      attendee.has_royal_family_connections = nil
      expect(attendee).not_to be_valid

      attendee.has_royal_family_connections = false
      expect(attendee).to be_valid
    end

    it "allows royal family connections field details to be blank" do
      attendee.has_royal_family_connections = false
      expect(attendee).to be_valid
    end

    it "requires royal family connection details field" do
      attendee.has_royal_family_connections = true
      expect(attendee).not_to be_valid
    end
  end
end
