require "rails_helper"

describe "Log in" do
  let(:subject) { create(:assessor, :lead_for_all, password: "my98ssdkjv9823kds=2") }

  it "logs in" do
    visit "/assessors/sign_in"
    fill_in "Email", with: subject.email
    fill_in "Password", with: "my98ssdkjv9823kds=2"
    click_button "Sign in"
    expect(page).to have_content "Applications"
  end

  it "can't log in if suspended" do
    subject.update!(suspended_at: Time.zone.now)

    visit "/assessors/sign_in"
    fill_in "Email", with: subject.email
    fill_in "Password", with: "my98ssdkjv9823kds=2"
    click_button "Sign in"
    expect(page).not_to have_content "Applications"
    expect(page).to have_content "Your account has been temporarily disabled."
  end
end
