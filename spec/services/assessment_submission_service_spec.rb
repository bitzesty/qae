require "rails_helper"

describe AssessmentSubmissionService do
  include FormAnswerTestMethods

  subject { described_class.new(assessment, assessor) }

  let(:form_answer) { create(:form_answer, :trade, :submitted) }
  let(:document) { { "verdict_desc" => "description NOT to copy", "verdict_rate" => "positive" } }
  let(:assessor) { create(:assessor, :lead_for_all) }

  before do
    allow_any_instance_of(AssessorAssignment).to receive(:valid?).and_return(true)
    assessment.document = document

    primary = form_answer.assessor_assignments.primary
    primary.assessor_id = assessor.id
    primary.document = { "verdict_desc" => "description to copy", "verdict_rate" => "negative" }
    primary.save!

    create(:settings, :expired_submission_deadlines)
    form_answer.state_machine.perform_transition(:assessment_in_progress)
  end

  context "moderated form submission" do
    let(:assessment) { form_answer.assessor_assignments.moderated }

    it "populates the lead case summary form with values from primary form" do
      expected = {
        "verdict_desc" => "description to copy",
        "verdict_rate" => "positive"
      }

      expect { expect_to_submit }.to change {
        form_answer.assessor_assignments.case_summary.document == expected
      }.from(false).to(true)
    end
  end

  context "case summary submission" do
    let(:form_answer) { create(:form_answer, :development, :submitted) }
    let(:assessment) { form_answer.assessor_assignments.case_summary }

    it "performs state transition when case summary is submitted" do
      assessment.document =  { "verdict_desc" => "description to copy", "verdict_rate" => "negative" }

      subject.perform
      expect(form_answer.reload.state).to eq("not_recommended")
    end
  end
end

def expect_to_submit
  expect { subject.perform }.to change { assessment.submitted? }.from(false).to(true)
end
