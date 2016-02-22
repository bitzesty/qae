require "rails_helper"
include Warden::Test::Helpers

describe  "User sees the post submission dashboard" do
  let(:user) { create(:user, :completed_profile) }
  let!(:form_answer) { create(:form_answer, :with_audit_certificate, user: user) }

  before do
    form_answer.state_machine.submit(user)
    login_as user
  end

  describe "visits the post submission dashboard", js: true do
    it "sees applications properly" do
      visit dashboard_path
      expect(page).to have_content"Edit application"
      expect(page).to have_content("Current Applications")

      settings = create(:settings, :expired_submission_deadlines)
      form_answer.update_column(:state, "reserved")

      visit dashboard_path
      expect_to_have_blank_dashboard

      settings.email_notifications.create!(
        kind: "shortlisted_notifier",
        trigger_at: DateTime.now - 1.year
      )
      visit dashboard_path

      #expect(page).to have_content("Congratulations! Your application was shortlisted.")
      #expect(page).to have_content("Declaration of Corporate Responsibility")
      form_answer.update_column(:state, "not_awarded")
      visit dashboard_path

      settings.email_notifications.create!(
        kind: "unsuccessful_notification",
        trigger_at: DateTime.now - 1.year
      )

      visit dashboard_path
      expect(page).to have_content("Your following application was unsuccessful.")

      form_answer.update_column(:state, "awarded")
      visit dashboard_path
      expect_to_have_blank_dashboard

      settings.email_notifications.create!(
        kind: "winners_notification",
        trigger_at: DateTime.now - 1.year
      )

      visit dashboard_path
      expect(page).to have_content("Congratulations on winning a Queen's Award for Enterprise")
      expect(page).to have_content("You will be notified when your press book notes are ready.")

      create :press_summary, form_answer: form_answer, approved: true

      visit dashboard_path
      expect(page).to have_link("Press Book Notes")
    end
  end
end

def expect_to_have_blank_dashboard
  expect(page).to_not have_content("Shortlisted")
  expect(page).to_not have_content("Unsuccessful")
  expect(page).to_not have_content("Successful")
end
