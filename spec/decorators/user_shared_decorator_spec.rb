require "rails_helper"

describe UserSharedDecorator do
  let(:user) do
    build_stubbed(:user, first_name: "John",
                         last_name: "Doe",
                         last_sign_in_at: DateTime.new(2015, 2, 6, 8, 30)).decorate
  end

  describe "#full_name" do
    it "Returns the first_name and last_name concatenated if present" do
      expect(user.full_name).to eq("John Doe")
    end

    it "Returns Anonymous if first_name is not present" do
      user.first_name = nil
      expect(user.full_name).to eq("Anonymous")
    end
  end

  describe "#formatted_last_sign_in_at_long" do
    it "Returns the expected format" do
      expect(user.formatted_last_sign_in_at_long).to eq(" 6 Feb 2015 at 8:30am")
    end
  end

  describe "#formatted_last_sign_in_at_short" do
    it "Returns the expected format" do
      expect(user.formatted_last_sign_in_at_short).to eq("06/02/2015 8:30am")
    end
  end
end
