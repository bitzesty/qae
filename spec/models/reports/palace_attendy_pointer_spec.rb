require "rails_helper"

describe Reports::PalaceAttendeePointer do
  describe "#call_method" do
    it "should return missing method" do
      expect(Reports::PalaceAttendeePointer.new(build(:palace_attendee)).call_method(:missing)).to eq "missing method"
    end
  end
end
