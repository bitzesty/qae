require "rails_helper"

describe FormAnswerStateMachine do
  let!(:award_year) {AwardYear.current}
  let(:form_answer) {create(:form_answer, :innovation, award_year: award_year)}

  describe "#submit" do
    context "before the submission deadline" do
      it "changes state/flag for application to submitted" do
        form_answer.state_machine.submit(form_answer.user)
        expect(form_answer).to be_submitted
        expect(form_answer.state).to eq("submitted")
      end

      it "sets up the transitions record with metadata" do
        form_answer.state_machine.submit(form_answer.user)
        expect(form_answer.form_answer_transitions.last.transitable).to eq(form_answer.user)
      end
    end
  end

  describe "#trigger_deadlines" do
    context "deadline expired" do
      let!(:settings) {create(:settings, :expired_submission_deadlines)}

      describe "assessment_in_progress -> withdrawn" do
        let(:lead) {create(:assessor, :lead_for_all)}
        it "sends notification for the Lead Assessor" do
          expect(Assessors::GeneralMailer).to receive(
                                                  :led_application_withdrawn).and_return(double(deliver_later!: true))
          form_answer.update_column(:state, "assessment_in_progress")
          form_answer.state_machine.perform_transition(:withdrawn, lead)
          expect(form_answer.reload.state).to eq("withdrawn")
        end
      end

      context "applications submitted" do
        before {form_answer.update(state: "submitted")}
        it "automatically changes state to `assessment_in_progress`" do
          expect {
            FormAnswerStateMachine.trigger_deadlines
          }.to change {
            form_answer.reload.state
          }.from("submitted").to("assessment_in_progress")
        end
      end

      context "applications in progress" do
        it "automatically changes state to `not_submitted`" do
          expect {
            FormAnswerStateMachine.trigger_deadlines
          }.to change {
            form_answer.reload.state
          }.from("eligibility_in_progress").to("not_submitted")
        end
      end
    end
  end

  describe "#trigger_audit_deadlines" do
    context "deadline expired" do
      let!(:mobility_fa) { create(:form_answer, :mobility, state: "assessment_in_progress") }
      let!(:settings) { create(:settings, :expired_audit_submission_deadline, :expired_submission_deadlines) }

      context "VoCF forms" do
        before do
          sdw = create(:shortlisted_documents_wrapper, form_answer: mobility_fa)
          create(:vat_returns_file, shortlisted_documents_wrapper: sdw)
          sdw.submit

          form_answer.update(state: "assessment_in_progress")
        end

        it "automatically changes state to `disqualified`" do
          expect {
            FormAnswerStateMachine.trigger_audit_deadlines
          }.to change {
            form_answer.reload.state
          }.from("assessment_in_progress").to("disqualified")

          expect(mobility_fa.reload.state).to eq("assessment_in_progress")
        end
      end

      context "non-VoCF forms" do
        before do
          mobility_fa.document["product_estimated_figures"] = "yes"
          mobility_fa.document["product_estimates_use"] = "text"
          mobility_fa.save!

          form_answer.update(state: "assessment_in_progress")
          create(:audit_certificate, form_answer: form_answer)
        end

        it "automatically changes state to `disqualified`" do
          expect {
            FormAnswerStateMachine.trigger_audit_deadlines
          }.to change {
            mobility_fa.reload.state
          }.from("assessment_in_progress").to("disqualified")

          expect(form_answer.reload.state).to eq("assessment_in_progress")
        end
      end
    end
  end

  context "#after_eligibility_step_failure" do
    it "should change state  to not_eligible" do
      form_answer.state_machine.after_eligibility_step_failure
      expect(form_answer.reload.state).to eq("not_eligible")
    end
  end

  context "#permitted_states_with_deadline_constraint" do
    it "should return correct state " do
      allow(Settings).to receive(:after_current_submission_deadline?) {true}
      form_answer.state = :not_eligible
      expect(form_answer.state_machine.send(:permitted_states_with_deadline_constraint)).to eq []
      form_answer.state = :not_submitted
      expect(form_answer.state_machine.send(:permitted_states_with_deadline_constraint)).to eq []
    end
  end

  describe "#perform_transition" do
    context "after the deadline" do
      let!(:settings) {create(:settings, :expired_submission_deadlines)}
      context "as Assessor" do
        let(:lead) {create(:assessor, :lead_for_all)}
        it "can change state only to allowed" do
          form_answer.state_machine.perform_transition(:submitted, lead)
          expect(form_answer.reload.state).to_not eq("submitted")
          form_answer.state_machine.perform_transition(:not_submitted, lead)
          expect(form_answer.reload.state).to eq("not_submitted")
        end
      end
    end

    context "feedback creation" do
      #
      # In 2017 we removed Key Strengths for Sust.development form
      # But for 2016 they should be
      # So that we are creating form_answer on this test case for 2016
      # as for 2017 this spec is not actual
      #

      let(:year_2016) {AwardYear.create!(year: 2016)}
      let(:form_answer) {create(:form_answer, :development, :submitted, award_year: year_2016)}
      let(:assessment) {form_answer.assessor_assignments.primary}
      let(:assessor) {create(:assessor, :regular_for_all)}
      let!(:settings) {create(:settings, :expired_submission_deadlines)}

      before do
        assessment.assessor = assessor
        assessment.save!
      end

      it "creates populated feedback" do
        assessment.document = { "environment_protection_rate" => "negative", "industry_sector_rate" => "positive" }
        assessment.save!

        form_answer.state_machine.perform_transition(:assessment_in_progress, assessor)
        form_answer.state_machine.perform_transition(:not_recommended, assessor)
        expect(form_answer.reload.feedback).not_to be_nil

        expect(form_answer.feedback.document["environment_protection_rate"]).to eq("negative")
        expect(form_answer.feedback.document["industry_sector_rate"]).to eq("positive")
      end
    end
  end
end
