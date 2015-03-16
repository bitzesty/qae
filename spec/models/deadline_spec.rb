require 'rails_helper'
require "models/shared/formatted_time_for_examples"

RSpec.describe Deadline do
  describe "#trigger_at" do
    include_examples "date_time_for", :trigger_at
  end

  describe "#passed?" do
    it "returns true when deadline is passed" do
      deadline = Deadline.new(trigger_at: Time.zone.now - 2.hours)
      expect(deadline).to be_passed
    end

    it "returns false when deadline is not passed" do
      deadline = Deadline.new(trigger_at: Time.zone.now + 2.hours)
      expect(deadline).not_to be_passed
    end

    it "returns false when deadline has no trigger_at" do
      deadline = Deadline.new
      expect(deadline).not_to be_passed
    end
  end
end
