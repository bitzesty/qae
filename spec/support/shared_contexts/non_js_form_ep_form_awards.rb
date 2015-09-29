require 'rails_helper'

shared_context "non js form ep form awards" do
  let!(:form_answer) do
    FactoryGirl.create :form_answer, :promotion,
      user: user,
      account: account,
      document: { company_name: "Bitzesty", question_namespace => awards }.merge(conditional_answer)
  end

  let!(:basic_eligibility) do
    FactoryGirl.create :basic_eligibility, form_answer: form_answer,
                                           account: account
  end

  let!(:promotion_eligibility) do
    FactoryGirl.create :promotion_eligibility, form_answer: form_answer,
                                               account: account
  end

  describe "Award interactions" do
    let(:new_award_title) { "Award3" }
    let(:new_award_details) { "Details3" }

    let(:first_award) { awards[0] }
    let(:second_award) { awards[1] }

    before do
      prepare_setting_deadlines
      login_as user
      visit edit_form_path(form_answer.id)
    end

    it "should display existing items in list" do
      within("#non_js_#{question_namespace}-list-question") do
        awards.each do |award|
          expect(page).to have_selector(
            "li[non-js-attribute=#{award[:title]}]", count: 1
          )
        end
      end
    end

    it "should allow to add another" do
      within("fieldset[data-answer=#{question_namespace}-list-them-below]") do
        click_link "+ Add Award/Personal honour"
      end
      expect_to_see "Add Award/Personal honour"

      expect {
        click_button "Save"
      }.to_not change {
        form_answer.reload.document
      }

      checked_fields = ["Award/personal honour title"]
      checked_fields.push("Year") if question_namespace == "awards"
      checked_fields.each do |field_name|
        expect_to_see "#{field_name}can't be blank"
      end

      fill_in "Award/personal honour title", with: new_award_title
      fill_in "Details", with: new_award_details
      if question_namespace == "awards"
        fill_in "Year", with: new_award_year
      end

      expect {
        click_button "Save"
      }.to change {
        form_answer.reload.document
      }

      within("#non_js_#{question_namespace}-list-question") do
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
      fill_in "Details", with: new_award_details
      if question_namespace == "awards"
        fill_in "Year", with: new_award_year
      end

      expect {
        click_button "Save"
      }.to change {
        form_answer.reload.document
      }

      within("#non_js_#{question_namespace}-list-question") do
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

      within("#non_js_#{question_namespace}-list-question") do
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
