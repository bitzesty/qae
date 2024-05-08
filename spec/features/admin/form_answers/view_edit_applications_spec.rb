require "rails_helper"
include Warden::Test::Helpers

feature "Admin view application", js: true do
  scenario "As an admin I can only see the application in read only mode" do
    application = create_application
    login_admin(create(:admin))

    visit admin_form_answer_path(application)

    expect(page).to have_content("View application")
    expect(page).to_not have_content("Edit application")

    application_window = window_opened_by { click_link("View application") }
    within_window application_window do
      expect(page).to have_current_path edit_form_path(application)
      expect(find_field("form[head_of_business_first_name]", disabled: true).value).to eq("David")
    end
  end

  scenario "As an admin I can edit the application if superadmin" do
    Settings.current.deadlines.innovation_submission_start.update(trigger_at: 1.day.ago)

    application = create_application
    login_admin(create(:admin, superadmin: true))

    visit admin_form_answer_path(application)

    expect(page).to have_content("View application")
    expect(page).to have_content("Edit application")

    application_window = window_opened_by { click_link("Edit application") }
    within_window application_window do
      expect(page).to have_current_path edit_form_path(application)
      expect(find_field("form[head_of_business_first_name]").value).to eq("David")
    end
  end

  scenario "As a superadmin I can edit the application even when submission is due date" do
    Settings.current.deadlines.innovation_submission_start.update(trigger_at: 1.day.ago)
    update_current_submission_deadline

    application = create_application
    login_admin(create(:admin, superadmin: true))

    visit admin_form_answer_path(application)

    expect(page).to have_content("View application")
    expect(page).to have_content("Edit application")

    application_window = window_opened_by { click_link("Edit application") }
    within_window application_window do
      expect(page).to have_current_path edit_form_path(application)
      expect(find_field("form[head_of_business_first_name]").value).to eq("David")
    end
  end
end

def create_application
  user = create :user, :completed_profile, first_name: "Test User john"
  form_answer = create :form_answer, :innovation,
    user: user,
    urn: "QA0001/19T",
    document: { head_of_business_first_name: "David" }
  create :basic_eligibility, form_answer: form_answer, account: user.account
  create :innovation_eligibility, form_answer: form_answer, account: user.account
  form_answer
end
