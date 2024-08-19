require "rails_helper"

describe ApplicationDecorator do
  let(:date) { DateTime.new(2015, 2, 6, 8, 30) }

  describe "#created_at" do
    it "Returns the expected format" do
      user = build_stubbed(:user, created_at: date).decorate
      expect(user.created_at).to eq("Feb_06_2015")
    end
  end

  describe "#created_at_timestamp" do
    it "Returns the expected format" do
      user = build_stubbed(:user, created_at: date).decorate
      expect(user.created_at_timestamp).to eq("06022015_8:30am")
    end
  end
end
