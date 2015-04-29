require 'rails_helper'
include Warden::Test::Helpers

describe "Non JS | Dynamic Lists | EP Form Nominee Background", %q{
As a User
I want to be able to add Nominee Background
So that I can fill form completelly even if Javascript is turned off
} do

  include_context "non js form base"

  let(:question_key) { "position_details" }

  let(:positions) do
    [
      {
        name: "position1",
        details: "Details1",
        ongoing: "0",
        start_month: "01",
        start_year: "2010",
        end_month: "02",
        end_year: "2011"
      },
      {
        name: "position2",
        details: "Details2",
        ongoing: "0",
        start_month: "03",
        start_year: "2012",
        end_month: "04",
        end_year: "2013"
      },
    ]
  end

  let!(:form_answer) do
    FactoryGirl.create :form_answer, :promotion,
      user: user,
      account: account,
      document: { company_name: "Bitzesty", question_key => positions.map(&:to_json) }
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

  describe "Nominee Background interactions" do
    let(:new_item) do
      {
        name: "position3",
        details: "Details3",
        ongoing: "0",
        start_month: "05",
        start_year: "2014",
        end_month: "06",
        end_year: "2015"
      }
    end

    let(:first_item) { positions[0] }
    let(:second_item) { positions[1] }

    before do
      visit form_form_answer_positions_path(form_answer.id)
    end

    it "should display existing items in list" do
      positions.each do |position|
        expect_to_see_entry(position)
      end
    end

    it "should allow to add another" do
      click_link "+ Add another role"
      expect_to_see "Add Role"

      expect {
        click_button "Save"
      }.to_not change {
        form_answer.reload.document
      }

      expect_to_see "Position/Rolecan't be blank"
      expect_to_see "Start month can't be blank"
      expect_to_see "End month can't be blank"

      fill_in_form(new_item)

      expect {
        click_button "Save"
      }.to change {
        form_answer.reload.document
      }

      positions.each do |position|
        expect_to_see_entry(position)
      end

      expect_to_see_entry(new_item)
    end

    it "should allow to update existing" do
      within("li[non-js-attribute=#{second_item[:name]}]") do
        click_link "Edit role"
      end
      expect_to_see "Edit Role"

      fill_in_form(new_item)

      expect {
        click_button "Save"
      }.to change {
        form_answer.reload.document
      }

      expect_to_see_entry(first_item)
      expect_to_see_entry(new_item)
      expect_to_see_no_entry(second_item)
    end

    it "should allow to remove existing" do
      within("li[non-js-attribute=#{second_item[:name]}]") do
        expect {
          click_button "Remove"
        }.to change {
          form_answer.reload.document
        }
      end

      expect_to_see_entry(first_item)
      expect_to_see_no_entry(second_item)
    end
  end

  private

  def expect_to_see_entry(item)
    expect_to_see item[:name]
    expect_to_see item[:start_month] + "/" + item[:start_year]
    expect_to_see item[:end_month] + "/" + item[:end_year]
    expect_to_see item[:details]
  end

  def expect_to_see_no_entry(item)
    expect_to_see_no item[:name]
    expect_to_see_no item[:start_month] + "/" + item[:start_year]
    expect_to_see_no item[:end_month] + "/" + item[:end_year]
    expect_to_see_no item[:details]
  end

  def fill_in_form(item)
    fill_in "Position/Role", with: item[:name]
    fill_in "position[start_month]", with: item[:start_month]
    fill_in "position[start_year]", with: item[:start_year]
    fill_in "position[end_month]", with: item[:end_month]
    fill_in "position[end_year]", with: item[:end_year]
    fill_in "Details", with: item[:details]
  end
end
