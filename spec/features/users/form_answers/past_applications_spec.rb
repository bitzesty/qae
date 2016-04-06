require "rails_helper"
include Warden::Test::Helpers

describe "Past Applications", %q{
As a Applicant
I want to be able to see Past Applications for previous years
So that I see
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
end
