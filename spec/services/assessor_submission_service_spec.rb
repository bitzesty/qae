require "rails_helper"

describe AssessmentSubmissionService do
  subject { described_class.new(assessment) }

  let(:form_answer) { create(:form_answer, :trade) }
  let(:document) { { "dumb_key" => "1" } }

  before do
    allow_any_instance_of(AssessorAssignment).to receive(:valid?).and_return(true)
    assessment.document = document
  end

  context "moderated form submission" do
    let(:assessment) { form_answer.assessor_assignments.moderated }

    it "populates the primary case summary form with values from moderated form" do
      expect_to_submit
      expect(form_answer.assessor_assignments.primary_case_summary.document).to eq(document)
    end
  end

  context "primary case summary submission" do
    let(:assessment) { form_answer.assessor_assignments.primary_case_summary }

    it "populates the lead case summary form with values from primary case summary" do
      expect_to_submit
      expect(form_answer.assessor_assignments.lead_case_summary.document).to eq(document)
    end
  end
end

def expect_to_submit
  expect { subject.perform }.to change { assessment.submitted? }.from(false).to(true)
end
