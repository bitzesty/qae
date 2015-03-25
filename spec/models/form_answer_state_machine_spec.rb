require "rails_helper"

describe FormAnswerStateMachine do
  let(:form_answer) { create(:form_answer, :innovation) }
  describe "#trigger_deadlines" do
    context "deadline expired" do
      let(:settings) { create(:settings, :expired_submission_deadlines) }
      before { form_answer.update(award_year: settings.year+1) }

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
end
