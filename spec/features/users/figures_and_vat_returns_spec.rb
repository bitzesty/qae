require "rails_helper"

describe "User uploads VAT returns and actual figures" do
  let(:user) { create(:user, :completed_profile) }
  let!(:settings) { create(:settings, :expired_submission_deadlines, award_year_id: AwardYear.current.id) }
  let!(:form_answer) { create(:form_answer, :mobility, :recommended, user: user) }

  before do
    form_answer.document["product_estimated_figures"] = "yes"
    form_answer.document["product_estimates_use"] = "text"
    form_answer.save!

    login_as user

    settings.email_notifications.create!(
      kind: "shortlisted_notifier",
      trigger_at: DateTime.now - 1.day,
    )
  end

  it "allows to submit vat returns and actual figures" do
    visit dashboard_url

    expect(page).to have_content("Congratulations! Your application was shortlisted.")

    click_link "Provide the latest financial information"

    # can't submit without a single vat returns file
    click_button "Confirm submission"
    expect(page).to have_content("You need to add at least one VAT returns file")

    # uploading actual figures
    within(".vat-returns-wrapper") do
      click_link "Upload a file"
    end

    attach_file("Upload VAT returns", Rails.root + "spec/fixtures/cat.jpg")

    click_button "Upload"

    expect(page).to have_link("cat.jpg")

    # uploading actual figures
    within(".actual-figures-wrapper") do
      click_link "Upload a file"
    end

    attach_file("Variance explanation document (if applicable)", Rails.root + "spec/fixtures/users.csv")

    click_button "Upload"

    expect(page).to have_link("users.csv")

    click_button "Confirm submission"

    expect(page).to have_text("Complete")
  end
end
