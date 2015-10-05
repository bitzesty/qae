require "rails_helper"

describe AssessmentSubmissionService do
  include FormAnswerTestMethods

  subject { described_class.new(assessment, assessor) }

  let(:form_answer) { create(:form_answer, :trade) }
  let(:document) { { "verdict_desc" => "description NOT to copy", "verdict_rate" => "positive" } }
  let(:assessor) { create(:assessor, :lead_for_all) }

  before do
    allow_any_instance_of(AssessorAssignment).to receive(:valid?).and_return(true)
    assessment.document = document

    primary = form_answer.assessor_assignments.primary
    primary.assessor_id = assessor.id
    primary.document = { "verdict_desc" => "description to copy", "verdict_rate" => "negative" }
    primary.save!
  end

  context "moderated form submission" do
    let(:assessment) { form_answer.assessor_assignments.moderated }

    it "populates the lead case summary form with values from primary form" do
      expected = {
        "verdict_desc" => "description to copy",
        "verdict_rate" => "positive"
      }

      expect { expect_to_submit }.to change {
        form_answer.assessor_assignments.lead_case_summary.document == expected
      }.from(false).to(true)
    end
  end
end

def expect_to_submit
  expect { subject.perform }.to change { assessment.submitted? }.from(false).to(true)
end
