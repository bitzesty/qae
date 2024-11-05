require "rails_helper"

describe "Admin fulfills the Palace Attendees" do
  let!(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer, :promotion, state: "awarded") }

  before do
    login_admin(admin)
    # TODO stub the winner condition
    form_answer.create_palace_invite
    visit admin_form_answer_path(form_answer)
  end

  context "js disabled" do
    it "adds multiple Palace Attendee" do
      field_values = []
      within "#section-palace-attendees" do
        first(".form-edit-link").click
        within first("#new_palace_attendee") do
          all("input.form-control").each_with_index do |input, index|
            val = "val-#{index}"

            field_values << val
            input.set(val)
          end
          find("input#palace_attendee_has_royal_family_connections_true").set(true)
          find("input#palace_attendee_disabled_access_true").set(true)

          click_button "Save"
        end
      end
    end
  end

  context "js enabled", js: true do
    let(:title) { "Mr" }
    let(:first_name) { "Bob" }
    let(:last_name) { "Buttons" }
    let(:job_name) { "Fisherman" }
    let(:post_nominals) { "Yeah that" }
    let(:royal_family_connection_details) { "Cleaner" }
    let(:address_1) { "123 Fake Street" }
    let(:address_2) { "Electric Avenue" }
    let(:address_3) { "Mordoor" }
    let(:address_4) { "The World" }
    let(:postcode) { "DA7 4HE" }
    let(:phone_number) { "02083015556" }
    let(:dietary_requirements) { "Meat eater" }

    it "adds the single Palace Attendee" do
      find("#palace-attendees-heading .panel-title a").click
      within "#section-palace-attendees" do
        find(".form-edit-link").click
        within "#new_palace_attendee" do
          # waiting for the last input to be rendered
          find("input#palace_attendee_phone_number")
          find("input#palace_attendee_has_royal_family_connections_true").set(true)
          find("input#palace_attendee_disabled_access_true").set(true)
          fill_in "palace_attendee_royal_family_connection_details", with: royal_family_connection_details
          find("#palace_attendee_title").set(title)
          find("#palace_attendee_first_name").set(first_name)
          find("#palace_attendee_last_name").set(last_name)
          find("#palace_attendee_job_name").set(job_name)
          find("#palace_attendee_post_nominals").set(post_nominals)
          find("#palace_attendee_address_1").set(address_1)
          find("#palace_attendee_address_2").set(address_2)
          find("#palace_attendee_address_3").set(address_3)
          find("#palace_attendee_address_4").set(address_4)
          find("#palace_attendee_postcode").set(postcode)
          find("#palace_attendee_phone_number").set(phone_number)
          find("#palace_attendee_dietary_requirements").set(dietary_requirements)
        end

        click_button "Save"
        wait_for_ajax
      end

      visit admin_form_answer_path(form_answer)
      find("#palace-attendees-heading .panel-title a").click

      within "#section-palace-attendees" do
        expect(page).to have_content(title)
        expect(page).to have_content(first_name)
        expect(page).to have_content(last_name)
        expect(page).to have_content(job_name)
        expect(page).to have_content(post_nominals)
        expect(page).to have_content(address_1)
        expect(page).to have_content(address_2)
        expect(page).to have_content(address_3)
        expect(page).to have_content(address_4)
        expect(page).to have_content(postcode)
        expect(page).to have_content(phone_number)
        expect(page).to have_content(dietary_requirements)
        expect(page).to have_content(royal_family_connection_details)
      end
    end
  end
end
