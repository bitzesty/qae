require "rails_helper"

describe FormAnswerStateMachine do
  let(:form_answer) { create(:form_answer, :innovation) }
  describe "#trigger_deadlines" do
    context "deadline expired" do
      let(:settings) { create(:settings, :expired_submission_deadlines) }
      before { form_answer.update(award_year: settings.year + 1) }

      context "applications submitted" do
        before { form_answer.update(state: "submitted") }
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
          }.from("application_in_progress").to("not_submitted")
        end
      end
    end
  end

  describe "application_in_progress -> withdrawn" do
    let(:lead) { create(:assessor, :lead_for_all) }
    it "sends notification for the Lead Assessor" do
      expect(Assessors::GeneralMailer).to receive(
        :led_application_withdrawn).and_return(double(deliver_later!: true))

      form_answer.state_machine.perform_transition(:withdrawn, lead)
      expect(form_answer.reload.state).to eq("withdrawn")
    end
  end

  describe "#perform_transition" do
    context "after the deadline" do
      let!(:settings) { create(:settings, :expired_submission_deadlines) }
      context "as Assessor" do
        let(:lead) { create(:assessor, :lead_for_all) }
        it "can change state only to allowed" do
          form_answer.state_machine.perform_transition(:submitted, lead)
          expect(form_answer.reload.state).to_not eq("submitted")
          form_answer.state_machine.perform_transition(:not_submitted, lead)
          expect(form_answer.reload.state).to eq("not_submitted")
        end
      end
    end
  end
end
