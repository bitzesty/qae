require "rails_helper"
include Warden::Test::Helpers

describe "Admin fulfills the Palace Attendees" do
  let!(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer, :promotion) }

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
        find(".form-edit-link").click
        within first("#new_palace_attendee") do
          all("input.form-control").each_with_index do |input, index|
            val = "val-#{index}"
            field_values << val
            input.set(val)
          end
          find("input[type='submit']").click
        end
      end
    end
  end

  context "js enabled", js: true do
    it "adds the single Palace Attendee" do
      field_values = []

      find("#palace-attendees-heading .panel-title a").click
      within "#section-palace-attendees" do
        find(".form-edit-link").click
        within "#new_palace_attendee" do
          all("input.form-control").each_with_index do |input, index|
            val = "val-#{index}"
            field_values << val
            input.set(val)
          end
        end
        find("input[type='submit']").click
        wait_for_ajax
      end
      visit admin_form_answer_path(form_answer)
      find("#palace-attendees-heading .panel-title a").click

      within "#section-palace-attendees" do
        field_values.each do |val|
          expect(page).to have_content(val)
        end
      end
    end

    it "adds multiple Palace Attendees" do
      field_values = []
      find("#palace-attendees-heading .panel-title a").click
      within "#section-palace-attendees" do
        find(".form-edit-link").click

        within first(".list-attendees") do
          all("input.form-control").each_with_index do |input, index|
            val = "val-#{index}"
            field_values << val
            input.set(val)
          end
          find("input[type='submit']").click
          wait_for_ajax
        end
        find(".add-another-attendee").click

        within all(".list-attendees").last do
          all("input.form-control").each_with_index do |input, index|
            index = field_values.size + index
            val = "val-#{index}"
            field_values << val
            input.set(val)
          end
          find("input[type='submit']").click
          wait_for_ajax
        end
      end

      visit admin_form_answer_path(form_answer)
      find("#palace-attendees-heading .panel-title a").click

      field_values.each do |val|
        expect(page).to have_content(val)
      end
    end
  end
end
