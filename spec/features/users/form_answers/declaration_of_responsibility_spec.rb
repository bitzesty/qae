require "rails_helper"
include Warden::Test::Helpers

describe "Corporate Responsibility Form" do
  DCR_OPTIONS = [
    :impact_on_society,
    :impact_on_environment,
    :partners_relations,
    :employees_relations,
    :customers_relations
  ]

  let(:user) do
    create :user
  end

  let!(:form_answer) do
    f = create :form_answer, :innovation, user: user
    f.document["corp_responsibility_form"] = "declare_now"
    f.save!

    f
  end

  before do
    login_as user
  end

  describe "Access restriction rules" do
    describe "Full DCR selected" do
      before do
        form_answer.state = "recommended"
        form_answer.document["corp_responsibility_form"] = "complete_now"
        form_answer.save!

        visit edit_users_form_answer_declaration_of_responsibility_path(form_answer)
      end

      it "should restrict access" do
        expect_to_see "Available for short DCR selected only!"
        expect_to_see_no "Please complete the full corporate responsibility form now you are shortlisted."
      end
    end

    describe "Application is not Shortlisted" do
      before do
        form_answer.state = "not recommended"
        form_answer.save!

        visit edit_users_form_answer_declaration_of_responsibility_path(form_answer)
      end

      it "should restrict access" do
        expect_to_see "This section available for shortlisted forms only!"
        expect_to_see_no "Please complete the full corporate responsibility form now you are shortlisted."
      end
    end

    describe "Cant' submit Declaration twice!" do
      before do
        form_answer.state = "recommended"
        form_answer.corp_responsibility_submitted = true
        form_answer.save!

        visit edit_users_form_answer_declaration_of_responsibility_path(form_answer)
      end

      it "should restrict access" do
        expect_to_see "Declaration already submitted!"
        expect_to_see_no "Please complete the full corporate responsibility form now you are shortlisted."
      end
    end
  end

  describe "Application Shortlisted" do
    describe "Save" do
      before do
        form_answer.state = "recommended"
        form_answer.corp_responsibility_submitted = false
        DCR_OPTIONS.each_with_index do |attr|
          form_answer.document[attr.to_s] = nil
        end
        form_answer.save!

        visit edit_users_form_answer_declaration_of_responsibility_path(form_answer)
      end

      let(:impact_on_society) { "impact_on_society".humanize }

      it "Saving and Submit Declaration" do
        # 1: DCR answers are missing
        #    No 'Submit Declaration' button as nothing to submit
        expect(page).to_not have_button('Submit Declaration')

        fill_in impact_on_society, with: impact_on_society
        click_button "Save"

        expect_to_see "Declaration of corporate responsibility was successfully saved"

        # 2: Not all DCR answers are answered
        #    No 'Submit Declaration' button as all answers are required to submit
        expect(page).to_not have_button('Submit Declaration')

        DCR_OPTIONS.each_with_index do |attr, index|
          fill_in attr.to_s.humanize, with: attr.to_s.humanize
        end
        click_button "Save"

        # 3: Once all DCR answers are answered
        #    Then 'Submit Declaration' button appers
        expect(page).to have_button('Submit Declaration')

        click_button "Submit Declaration"
        expect_to_see "Declaration of corporate responsibility was successfully submitted"

        # 4: Trying to access DCR form after submission of declaration
        #    And getting restriction redirect with message
        visit edit_users_form_answer_declaration_of_responsibility_path(form_answer)
        expect_to_see "Declaration already submitted!"
      end
    end
  end
end
