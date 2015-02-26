require "rails_helper"

describe Reports::AdminReportBuilder do
  let!(:form_answer) { create(:form_answer) }

  let(:output) { described_class.new.build }
  it "creates the output with relevant data" do
    expect(output).to include(form_answer.user_id.to_s)
  end
end
