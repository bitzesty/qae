require "rails_helper"

describe Settings do
  context "after create" do
    let(:settings) { Settings.current }
    let(:deadlines) {
      Deadline::AVAILABLE_DEADLINES.sort do |a, b|
        a <=> b
      end
    }

    it "creates all kinds of deadlines" do
      expect(settings.deadlines.count).to eq(9)
      expect(settings.deadlines.order(:kind).map(&:kind)).to eq(deadlines)
    end
  end
end
