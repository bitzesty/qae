require 'rails_helper'
include Warden::Test::Helpers

describe "Non JS | Dynamic Lists | Subsidiaries", %q{
As a User
I want to be able to add UK subsidiaries, associates or plants
So that I can fill form completelly even if Javascript is turned off
} do

  include_context "non js form base"

  let(:question_key) { "trading_figures_add" }

  let(:subsidiaries) do
    [
      { name: "location_name_1", location: "location1", employees: "10" },
      { name: "location_name_2", location: "location2", employees: "20" }
    ]
  end

  let!(:form_answer) do
    FactoryGirl.create :form_answer, :trade,
      user: user,
      account: account,
      document: { company_name: "Bitzesty", question_key => subsidiaries.map(&:to_json) }
  end

  let!(:basic_eligibility) do
    FactoryGirl.create :basic_eligibility, form_answer: form_answer,
                                           account: account
  end

  let!(:trade_eligibility) do
    FactoryGirl.create :trade_eligibility, form_answer: form_answer,
                                           account: account
  end

  before do
    prepare_setting_deadlines
    login_as user
  end

  describe "Subsidiaries interactions" do
    let(:new_name) { "location_name_3" }
    let(:new_location) { "location3" }
    let(:new_employees) { "15" }

    let(:first_item) { subsidiaries[0] }
    let(:second_item) { subsidiaries[1] }

    before do
      visit edit_form_path(form_answer.id)
    end

    it "should display existing items in list" do
      within("#non_js_#{question_key}-list-question") do
        subsidiaries.each do |subsidiary|
          expect(page).to have_selector(
            "li[non-js-attribute=#{subsidiary[:name]}]", count: 1
          )
        end
      end
    end

    it "should allow to add another" do
      within("fieldset[data-answer=#{question_key}-]") do
        first(".button-add.if-js-hide").click
      end
      expect_to_see "Add subsidiary, associate or plant"

      expect {
        click_button "Save"
      }.to_not change {
        form_answer.reload.document
      }

      ["Name", "Location", "Number of UK Employees"].each do |field_name|
        expect_to_see "#{field_name}can't be blank"
      end

      fill_in "Name", with: new_name
      fill_in "Location", with: new_location
      fill_in "Number of UK Employees", with: new_employees

      expect {
        click_button "Save"
      }.to change {
        form_answer.reload.document
      }

      within("#non_js_#{question_key}-list-question") do
        subsidiaries.each do |subsidiary|
          expect(page).to have_selector(
            "li[non-js-attribute=#{subsidiary[:name]}]", count: 1
          )
        end

        expect(page).to have_selector(
          "li[non-js-attribute=#{new_name}]", count: 1
        )
      end
    end

    it "should allow to update existing" do
      within("li[non-js-attribute=#{second_item[:name]}]") do
        click_link "Edit"
      end
      expect_to_see "Edit subsidiary, associate or plant "

      fill_in "Name", with: new_name
      fill_in "Location", with: new_location
      fill_in "Number of UK Employees", with: new_employees

      expect {
        click_button "Save"
      }.to change {
        form_answer.reload.document
      }

      within("#non_js_#{question_key}-list-question") do
        expect(page).to have_selector(
          "li[non-js-attribute=#{first_item[:name]}]", count: 1
        )

        expect(page).to have_selector(
          "li[non-js-attribute=#{new_name}]", count: 1
        )

        expect(page).to_not have_selector(
          "li[non-js-attribute=#{second_item[:name]}]"
        )
      end
    end

    it "should allow to remove existing" do
      within("li[non-js-attribute=#{second_item[:name]}]") do
        first('a.remove-link.if-js-hide').click
      end

      expect_to_see "Are you sure?"

      expect {
        click_button "Delete"
      }.to change {
        form_answer.reload.document
      }

      within("#non_js_#{question_key}-list-question") do
        expect(page).to have_selector(
          "li[non-js-attribute=#{first_item[:name]}]", count: 1
        )

        expect(page).to_not have_selector(
          "li[non-js-attribute=#{second_item[:name]}]"
        )
      end
    end
  end
end
