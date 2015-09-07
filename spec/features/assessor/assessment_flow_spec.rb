require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "Assessment flow", %(
  As Assessor
  I want to participate in assessment flow.
), js: true do

  let!(:form_answer) { create(:form_answer, :innovation) }
  let!(:lead) { create(:assessor, :lead_for_all) }
  let!(:primary) { create(:assessor, :regular_for_innovation) }
  let(:text) { "textextextt" }

  before do
    p = form_answer.assessor_assignments.primary
    p.assessor = primary
    p.save
  end

  it "follows the appropriate assessment flow"
  # Needs to test the flow properly
  # Primary assessor submits appraisal form
  # Secondary assessor submits appraisal form
  # Lead assessor submits moderated form
  # Primary & Lead can edit the background on the Case summary (the rest is read only from primary assessor form and the overal verdict from moderated)
end