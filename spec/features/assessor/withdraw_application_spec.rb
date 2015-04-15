require "rails_helper"
include Warden::Test::Helpers

describe "Assessor withdraws the application", js: true do
  let!(:assessor) { create(:assessor, :lead_for_all) }
  let!(:form_answer) { create(:form_answer) }

  before do
    setting = Settings.current_submission_deadline
    setting.update(trigger_at: DateTime.now - 1.hour)
    login_as(assessor, scope: :assessor)
    form_answer.state_machine.perform_transition(:assessment_in_progress, nil, false)
  end

  describe "application withdrawn" do
    it "withdraws the app with the select box" do
      visit assessor_form_answer_path(form_answer)
      within ".section-applicant-status" do
        find(".state-toggle").click
      end

      all("li.checkbox").detect { |l| l.text == "Withdrawn" }.click
      wait_for_ajax
      expect(form_answer.reload.state).to eq("withdrawn")
    end
  end
end
