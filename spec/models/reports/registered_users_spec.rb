require "rails_helper"

describe Reports::RegisteredUsers do
  let!(:form_answer) { create(:form_answer) }

  let(:output) { described_class.new(Settings.current).build }
  it "creates the output with relevant data" do
    expect(output).to include(form_answer.user_id.to_s)
  end
end
