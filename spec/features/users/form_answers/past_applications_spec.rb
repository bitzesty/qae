require "rails_helper"
include Warden::Test::Helpers

describe "Past Applications", '
As an Applicant
I want to be able to see Past Applications for previous years
So that I see
' do
  let(:previous_year) do
    Date.new(2020, 4, 1)
  end

  let!(:previous_award_year) do
    create :award_year, year: previous_year.year
  end

  let!(:previous_award_year_settings) do
    settings = previous_award_year.settings

    start = settings.deadlines.where(kind: "submission_start").first
    start.update_column(:trigger_at, previous_year - 25.days)
    finish = settings.deadlines.where(kind: "submission_end").first
    finish.update_column(:trigger_at, previous_year - 20.days)

    settings.reload

    settings.email_notifications.create!(
      kind: "winners_notification",
      trigger_at: previous_year,
    )

    settings.email_notifications.create!(
      kind: "unsuccessful_notification",
      trigger_at: previous_year,
    )

    settings.reload

    settings
  end

  let!(:current_year_settings) do
    create(:settings, :submission_deadlines)
  end

  let!(:user) do
    create :user, :completed_profile, role: "account_admin"
  end

  let!(:collaborator) do
    create :user, :completed_profile, role: "regular", account: user.account
  end

  before do
    login_as(user, scope: :user)
  end

  describe "Displaying of past applications on dashboard" do
    describe "Successful Applications" do
      let!(:past_awarded_form_answer) do
        create(:form_answer, :innovation,
          :awarded,
          award_year: previous_award_year,
          user: user)
      end

      before do
        visit dashboard_path
      end

      it "should display past successful applications" do
        # save_and_open_page
        expect(page).to have_selector("div.dashboard-post-submission", count: 1)
      end
    end
  end
end
