require "rails_helper"
include Warden::Test::Helpers

describe "Non JS | Dynamic Lists | Current King's Awards", "
As a User
I want to be able to add Current King's Awards I hold
So that I can fill form completelly even if Javascript is turned off
" do
  include_context "non js form base"

  let(:innovation_award_year) do
    (Date.current - 2.years).year.to_s
  end

  let(:trade_award_year) do
    (Date.current - 1.year).year.to_s
  end

  let(:awards) do
    [
      { category: "innovation", year: innovation_award_year },
      { category: "international_trade", year: trade_award_year },
    ]
  end

  let!(:form_answer) do
    create :form_answer,
      :innovation,
      user: user,
      account: account,
      document: { company_name: "Bitzesty", applied_for_queen_awards: "yes", applied_for_queen_awards_details: awards }
  end

  let!(:basic_eligibility) do
    create :basic_eligibility,
      form_answer: form_answer,
      account: account
  end

  let!(:innovation_eligibility) do
    create :innovation_eligibility,
      form_answer: form_answer,
      account: account
  end

  before do
    prepare_setting_deadlines
    login_as user
  end

  describe "Current King's Awards interactions" do
    let(:new_award_category) { "sustainable_development" }
    let(:new_award_category_name) { "Sustainable Development" }
    let(:new_award_category_year) { (AwardYear.current.year - 1).to_s }

    let(:first_award) { awards[0] }
    let(:second_award) { awards[1] }

    before do
      visit edit_form_path(form_answer.id)
    end

    it "should display existing items in list" do
      within("#non_js_applied_for_queen_awards_details-list-question") do
        awards.each do |award|
          expect(page).to have_selector(
            "li[non-js-attribute=#{item_entry(award)}]", count: 1
          )
        end
      end
    end

    it "should allow to add another" do
      within("div[data-answer=applied_for_queen_awards_details-list-the-queen-s-king-s-awards-you-have-applied-for-in-the-last-10-years]") do
        click_link "+ Add award"
      end
      expect_to_see "Add Award"

      expect {
        click_button "Save"
      }.to_not change {
        form_answer.reload.document
      }

      %w[Category Year].each do |field_name|
        expect_to_see "#{field_name} is required and an option must be selected from the following list"
      end

      select new_award_category_name, from: "Category"
      select new_award_category_year, from: "Year"
      select "Won", from: "Outcome"

      expect {
        click_button "Save"
      }.to change {
        form_answer.reload.document
      }

      within("#non_js_applied_for_queen_awards_details-list-question") do
        awards.each do |award|
          expect(page).to have_selector(
            "li[non-js-attribute=#{item_entry(award)}]", count: 1
          )
        end

        expect(page).to have_selector(
          "li[non-js-attribute=#{new_award_category}_#{new_award_category_year}]", count: 1
        )
      end
    end

    it "should allow to update existing" do
      within("li[non-js-attribute=#{second_award[:category]}_#{second_award[:year]}]") do
        click_link "Edit"
      end
      expect_to_see "Edit Award"

      select new_award_category_name, from: "Category"
      select new_award_category_year, from: "Year"
      select "Won", from: "Outcome"

      expect {
        click_button "Save"
      }.to change {
        form_answer.reload.document
      }

      within("#non_js_applied_for_queen_awards_details-list-question") do
        expect(page).to have_selector(
          "li[non-js-attribute=#{item_entry(first_award)}]", count: 1
        )

        expect(page).to have_selector(
          "li[non-js-attribute=#{new_award_category}_#{new_award_category_year}]", count: 1
        )

        expect(page).to_not have_selector(
          "li[non-js-attribute=#{item_entry(second_award)}]",
        )
      end
    end

    it "should allow to remove existing" do
      within("li[non-js-attribute=#{second_award[:category]}_#{second_award[:year]}]") do
        first("a.remove-link.js-remove-link").click
      end

      expect_to_see "Are you sure?"

      expect {
        click_button "Delete"
      }.to change {
        form_answer.reload.document
      }

      within("#non_js_applied_for_queen_awards_details-list-question") do
        expect(page).to have_selector(
          "li[non-js-attribute=#{item_entry(first_award)}]", count: 1
        )

        expect(page).to_not have_selector(
          "li[non-js-attribute=#{item_entry(second_award)}]",
        )
      end
    end
  end

  private

  def item_entry(el)
    "#{el[:category]}_#{el[:year]}"
  end
end
