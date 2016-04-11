require "rails_helper"
include Warden::Test::Helpers

describe "Palace Attendees", %q{
As a Applicant
I want to be able to setup Palace attendees details
So that I provide a full list of attendees for Buckingham Palace reception
} do

  let!(:user) do
    create :user, :completed_profile, role: "account_admin"
  end

  let!(:form_answer) do
    create :form_answer, :innovation, :awarded, user: user
  end

  let!(:palace_invite) do
    create :palace_invite, form_answer: form_answer, email: user.email
  end

  let!(:settings) do
    s = create(:settings, :expired_submission_deadlines)
    s.email_notifications.create!(
      kind: "winners_notification",
      trigger_at: DateTime.now - 1.year
    )

    s
  end

  before do
    login_as(user, scope: :user)
  end

  describe "Access" do
    describe "Should be buckingham palace invites stage" do
      it "should reject applicant with access denied message" do
        visit dashboard_path
        expect(page).to_not have_link("Palace Attendees")

        visit edit_users_form_answer_palace_invite_path(form_answer)
        expect_to_see "Access denied!"

        settings.email_notifications.create!(
          kind: "buckingham_palace_invite",
          trigger_at: DateTime.now - 1.year
        )

        visit dashboard_path
        expect(page).to have_link("Palace Attendees")
      end
    end

    describe "Invite should be not submitted yet" do
      before do
        settings.email_notifications.create!(
          kind: "buckingham_palace_invite",
          trigger_at: DateTime.now - 1.year
        )
        palace_invite.submitted = true
        palace_invite.save!

        visit dashboard_path
      end

      it "should reject applicant with access denied message" do
        expect_to_see "Palace Attendees"
        expect(page).to_not have_link("Palace Attendees")

        visit edit_users_form_answer_palace_invite_path(form_answer)
        expect_to_see "Access denied!"
      end
    end
  end

  describe "Save & Submit" do
    before do
      settings.email_notifications.create!(
        kind: "buckingham_palace_invite",
        trigger_at: DateTime.now - 1.year
      )

      visit edit_users_form_answer_palace_invite_path(form_answer)
    end

    let(:title) { "MyTitle" }
    let(:my_first_name) { "MyFirstName" }
    let(:attendee) do
      palace_invite.reload.palace_attendees.first
    end

    describe "Save" do
      it "should allow to Save palace attendees as a draft without validation" do
        fill_in "Title", with: title
        fill_in "First name", with: my_first_name

        expect {
          click_on "Confirm Attendees"
        }.to_not change {
          palace_invite.reload.submitted
        }


        expect_to_see "This field cannot be blank"
        expect_to_see_no "Palace Attendees details are successfully submitted!"

        click_on "Save"

        expect(attendee.title).to be_eql(title)
        expect(attendee.first_name).to be_eql(my_first_name)

        expect_to_see "Attendee details have been successfully updated"
      end
    end

    describe "Submit" do
      it "should allow to Submit valid palace attendees" do
        fill_in "Title", with: title
        fill_in "First name", with: my_first_name
        fill_in "Surname", with: "Test"
        fill_in "Job Title / Position", with: "Test"
        fill_in "Decorations / Post Nominals", with: "Test"
        fill_in "Address 1", with: "Test"
        fill_in "Address 2", with: "Test"
        fill_in "Address 3", with: "Test"
        fill_in "Address 4", with: "Test"
        fill_in "Postcode", with: "Test"
        fill_in "Telephone number", with: "Test"

        expect {
          click_on "Confirm Attendees"
        }.to change {
          palace_invite.reload.submitted
        }

        expect(attendee.title).to be_eql(title)
        expect(attendee.first_name).to be_eql(my_first_name)

        expect_to_see "Palace Attendees details are successfully submitted!"
      end
    end
  end
end
