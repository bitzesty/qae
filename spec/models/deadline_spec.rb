require "rails_helper"
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

  describe "class methods" do
    it ".with_states_to_trigger should filter correctly" do
      time = Time.now
      target = Deadline.where(kind: "submission_end", states_triggered_at: nil).where("trigger_at < ?", time).to_sql
      expect(target).to eq Deadline.with_states_to_trigger(time).to_sql
    end

    it ".end_of_embargo should return correct result" do
      deadline = build(:deadline)
      allow(Deadline).to receive(:where).with(kind: "buckingham_palace_attendees_details") { [deadline] }
      expect(Deadline.end_of_embargo).to eq deadline
    end

    it ".buckingham_palace_attendees_invite should return correct result" do
      deadline = build(:deadline)
      allow(Deadline).to receive(:where).with(kind: "buckingham_palace_attendees_invite") { [deadline] }
      expect(Deadline.buckingham_palace_attendees_invite).to eq deadline
    end

    it ".buckingham_palace_media_information should return correct result" do
      deadline = build(:deadline)
      allow(Deadline).to receive(:where).with(kind: "buckingham_palace_media_information") { [deadline] }
      expect(Deadline.buckingham_palace_media_information).to eq deadline
    end
  end
end
