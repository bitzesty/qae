require 'rails_helper'
include Warden::Test::Helpers

describe "Non JS | Dynamic Lists | Awards", %q{
As a User
I want to be able to add Awards to Form application
So that I can fill form completelly even if Javascript is turned off
} do

  include_context "non js form base"

  let(:award_1) do
    (Date.today - 2.years).year.to_s
  end

  let(:award_2) do
    (Date.today - 1.years).year.to_s
  end

  let(:awards) do
    [
      {title: "Award1", details: "Details1", year: award_1},
      {title: "Award2", details: "Details2", year: award_2}
    ]
  end

  let!(:form_answer) do
    FactoryGirl.create :form_answer, :promotion,
      user: user,
      account: account,
      document: { company_name: "Bitzesty", awards: awards.map(&:to_json) }
  end

  let!(:basic_eligibility) do
    FactoryGirl.create :basic_eligibility, form_answer: form_answer,
                                           account: account
  end

  let!(:promotion_eligibility) do
    FactoryGirl.create :promotion_eligibility, form_answer: form_answer,
                                               account: account
  end

  before do
    prepare_setting_deadlines
    login_as user
  end

  describe "Award interactions" do
    let(:new_award_title) { "Award3" }
    let(:new_award_details) { "Details3" }
    let(:new_award_year) { Date.today.year.to_s }

    let(:first_award) { awards[0] }
    let(:second_award) { awards[1] }

    before do
      visit edit_form_path(form_answer.id)
    end

    it "should display existing items in list" do
      within("#non_js_awards-list-question") do
        awards.each do |award|
          expect(page).to have_selector(
            "li[non-js-attribute=#{award[:title]}]", count: 1
          )
        end
      end
    end

    it "should allow to add another" do
      within("fieldset[data-answer=awards-list-them-below]") do
        click_link "+ Add Award/Personal honour"
      end
      expect_to_see "Add Award/Personal honour"

      expect {
        click_button "Save"
      }.to_not change {
        form_answer.reload.document
      }

      ["Award/personal honour title", "Year"].each do |field_name|
        expect_to_see "#{field_name}can't be blank"
      end

      fill_in "Award/personal honour title", with: new_award_title
      fill_in "Year", with: new_award_year
      fill_in "Details", with: new_award_details

      expect {
        click_button "Save"
      }.to change {
        form_answer.reload.document
      }

      within("#non_js_awards-list-question") do
        awards.each do |award|
          expect(page).to have_selector(
            "li[non-js-attribute=#{award[:title]}]", count: 1
          )
        end

        expect(page).to have_selector(
          "li[non-js-attribute=#{new_award_title}]", count: 1
        )
      end
    end

    it "should allow to update existing" do
      within("li[non-js-attribute=#{second_award[:title]}]") do
        click_link "Edit"
      end
      expect_to_see "Edit Award/Personal honour"

      fill_in "Award/personal honour title", with: new_award_title
      fill_in "Year", with: new_award_year
      fill_in "Details", with: new_award_details

      expect {
        click_button "Save"
      }.to change {
        form_answer.reload.document
      }

      within("#non_js_awards-list-question") do
        expect(page).to have_selector(
          "li[non-js-attribute=#{first_award[:title]}]", count: 1
        )

        expect(page).to have_selector(
          "li[non-js-attribute=#{new_award_title}]", count: 1
        )

        expect(page).to_not have_selector(
          "li[non-js-attribute=#{second_award[:title]}]"
        )
      end
    end

    it "should allow to remove existing" do
      within("li[non-js-attribute=#{second_award[:title]}]") do
        first('a.remove-link.if-js-hide').click
      end

      expect_to_see "Are you sure?"

      expect {
        click_button "Delete"
      }.to change {
        form_answer.reload.document
      }

      within("#non_js_awards-list-question") do
        expect(page).to have_selector(
          "li[non-js-attribute=#{first_award[:title]}]", count: 1
        )

        expect(page).to_not have_selector(
          "li[non-js-attribute=#{second_award[:title]}]"
        )
      end
    end
  end
end
