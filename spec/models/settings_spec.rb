require "rails_helper"

describe Settings do
  context "after create" do
    let(:settings) { Settings.current }
    it "creates all kinds of deadlines" do
      expect(settings.deadlines.count).to eq(5)
      expected = %w(audit_certificates buckingham_palace_attendees_details press_release_comments submission_end submission_start)
      expect(settings.deadlines.order(:kind).map(&:kind)).to eq(expected)
    end
  end
end
