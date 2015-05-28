require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Eligibility forms" do
  let!(:user) { create(:user, :completed_profile) }

  before do
    create(:settings, :submission_deadlines)
    login_as(user, scope: :user)
  end

  context "trade" do
    it "process the eligibility form" do
      visit dashboard_path
      new_application("International Trade Award")
      fill_in("nickname", with: "trade nick")
      click_button("Save and start eligibility")

      form_choice([
        "Yes",
        "Yes",
        /Business/,
        /Product/,
        "Yes",
        "No",
        "Yes",
        "No",
        "Yes"
      ])
      expect(page).to have_content("Before you start your application")
      click_link "Continue"
      expect(page).to have_content("You are eligible to begin your application for an International Trade Award.")
    end
  end

  context "innovation" do
    it "process the eligibility form" do
      visit dashboard_path
      new_application("Innovation Award")
      fill_in("nickname", with: "innovation nick")
      click_button("Save and start eligibility")
      form_choice(["Yes", "Yes", /Business/, /Product/, "Yes", "No", "Yes"])

      fill_in("How many innovative products/services/initiatives do you have?", with: 2)
      click_button "Continue"
      form_choice("Yes")
      form_choice("Yes")
      expect(page).to have_content("Before you start your application")
      click_link "Continue"
      expect(page).to have_content("You are eligible to begin your application for an Innovation Award.")
    end
  end

  context "development" do
    it "process the eligibility form" do
      visit dashboard_path
      new_application("Sustainable Development Award")
      fill_in "nickname", with: "development nick"
      click_button "Save and start eligibility"
      form_choice([
        "Yes",
        "Yes",
        /Business/,
        /Product/,
        "Yes",
        "No",
        "Yes"
      ])
      expect(page).to have_content("Before you start your application")
      click_link "Continue"
      expect(page).to have_content("You are eligible to begin your application for a Sustainable Development Award.")
    end
  end

  context "promotion" do
    it "process the eligibility form" do
      visit dashboard_path
      new_application "Enterprise Promotion Award"
      fill_in "nickname", with: "promotion nick"
      click_button "Save and start eligibility"
      form_choice([
        /Someone/,
        "Yes",
        "Yes",
        "Yes",
        "Yes",
        "Yes",
        "No",
        "Yes",
        "No",
        "No",
        "Yes"
      ])
      expect(page).to have_content("Before you start your application")
      click_link "Continue"
      expect(page).to have_content("Your nominee is eligible for an Enterprise Promotion Award")
    end
  end
end

def form_choice(labels)
  label_ids = Array(labels)

  label_ids.each do |label_id|
    l = all(".question-body .selectable label").detect do |label|
      if label_id.is_a?(String)
        label.text == label_id
      elsif label_id.is_a?(Regexp)
        label.text =~ label_id
      end
    end

    l.find("input").set(true)
    click_button "Continue"
  end
end

def new_application(type)
  header = all(".applications-list li").detect { |app| app.first("h3", text: type) }
  header.first("a").click
end
