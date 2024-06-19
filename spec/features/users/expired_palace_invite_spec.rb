require "rails_helper"

Warden.test_mode!

describe "expired reception attendee information deadline" do
  let(:user) { create :user, :completed_profile }
  let!(:settings) { create(:settings, :submission_deadlines, award_year_id: AwardYear.current.id) }

  let!(:form_answer) {
    create :form_answer,
      :awarded,
      :trade,
      user: user,
      award_year_id: AwardYear.current.id
  }

  let!(:invite) { form_answer.create_palace_invite }
  let!(:palace_attendee) { create(:palace_attendee, palace_invite: invite) }

  let!(:deadline) {
    form_answer.award_year
               .fetch_deadline("buckingham_palace_reception_attendee_information_due_by")
  }

  before do
    AwardYear.buckingham_palace_reception_deadline(form_answer.award_year).update_column(:trigger_at, Time.current.end_of_year)

    expect(Settings).to receive(:buckingham_palace_invites_stage?)
                          .with(invite.form_answer.award_year.settings)
                          .and_return(true)

    login_as(user, scope: :user)
  end

  it "redirects user to help page without ability to submit the form when due date is over" do
    deadline.update_column(:trigger_at, Time.current - 1.day)

    visit edit_palace_invite_path(id: invite.token)

    expect(page).to have_content("It is past the deadline - please get in touch with us.")
  end

  it "allows user to fill the form within due date" do
    award_day = AwardYear.buckingham_palace_reception_deadline(form_answer.award_year).decorate.formatted_trigger_day
    award_date = AwardYear.buckingham_palace_reception_deadline(form_answer.award_year).decorate.formatted_trigger_time(date_format: "%-d %B %Y,")
    deadline.update_column(:trigger_at, Time.current + 1.day)

    visit edit_palace_invite_path(id: invite.token)

    expect(page).to have_content("On #{award_day}, #{award_date}, a Royal Reception at Windsor Castle will be held for organisations who have received this year's King's Award. Successful organisations can send one attendee per award won.")

    expect(page).to have_selector("form", id: "new_palace_invite")
    expect(page).to have_button("Confirm and submit attendee's details")
  end
end
