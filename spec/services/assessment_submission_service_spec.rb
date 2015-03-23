require "rails_helper"

describe AssessmentSubmissionService do
  include FormAnswerTestMethods

  subject { described_class.new(assessment, assessor) }

  let(:form_answer) { create(:form_answer, :trade) }
  let(:document) { { "dumb_key" => "1" } }
  let(:assessor) { create(:assessor, :lead_for_all) }

  before do
    allow_any_instance_of(AssessorAssignment).to receive(:valid?).and_return(true)
    assessment.document = document
  end

  context "moderated form submission" do
    let(:assessment) { form_answer.assessor_assignments.moderated }

    it "populates the primary case summary form with values from moderated form" do
      expect { expect_to_submit }.to change {
        form_answer.assessor_assignments.primary_case_summary.document == document
      }.from(false).to(true)
    end

    context "primary and lead is the same person" do
      before { assign_primary(form_answer, assessor) }
      it "populates primary case summary and lead at once" do
        expect { expect_to_submit }.to change {
          [
            form_answer.assessor_assignments.primary_case_summary.document == document,
            form_answer.assessor_assignments.lead_case_summary.document == document
          ]
        }.from([false, false]).to([true, true])
      end
    end
  end

  context "primary case summary submission" do
    let(:assessment) { form_answer.assessor_assignments.primary_case_summary }

    it "populates the lead case summary form with values from primary case summary" do
      expect { expect_to_submit }.to change {
        form_answer.assessor_assignments.lead_case_summary.document == document
      }.from(false).to(true)
    end
  end
end

def expect_to_submit
  expect { subject.perform }.to change { assessment.submitted? }.from(false).to(true)
end
