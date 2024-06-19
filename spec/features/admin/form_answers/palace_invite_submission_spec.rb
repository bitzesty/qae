require "rails_helper"

describe "Admin submits palace attendees' info" do
  let!(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer, :mobility, state: "awarded") }

  let!(:invite) do
    form_answer.create_palace_invite
  end

  let!(:palace_attendee) do
    create(:palace_attendee, palace_invite: invite)
  end

  before do
    login_admin(admin)
    visit admin_form_answer_path(form_answer)
  end

  context "js disabled" do
    it "submits Palace Attendee" do
      within "#palace-invite-submit-form" do
        click_button "Submit"
      end

      expect(page).to have_content("Palace attendees submitted")
    end
  end

  context "js enabled", js: true do
    it "submits palace attendee info" do
      find("#palace-attendees-heading .panel-title a").click

      within "#palace-invite-submit-form" do
        click_button "Submit"
      end

      wait_for_ajax
      expect(invite.reload.submitted).to be_truthy
      expect(page).to have_content("Palace attendees submitted")
    end
  end
end
