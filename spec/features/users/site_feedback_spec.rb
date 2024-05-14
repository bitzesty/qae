require "rails_helper"

describe "User leaves feedback and admin is able to see it" do
  let(:admin) { create :admin }

  it "creates feedback and admin is able to see it" do
    visit feedback_path

    choose "site_feedback_rating_satisfied"
    fill_in "site_feedback[comment]", with: "Pretty good"

    click_button "Send Feedback"
    expect(page).to have_content("Feedback was successfully sent")

    login_admin(admin)
    visit admin_users_feedback_path

    expect(page).to have_content("Pretty good")
  end
end
