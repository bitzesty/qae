require 'rails_helper'
include Warden::Test::Helpers

describe "Review 'read only' version of the form", %q{
As a Admin
I want to be able to see the forms (read only) but exactly as the user filling it in would see it
So that I can have 'read only' version of form
} do

  let!(:admin) do
    create(:admin)
  end

  let!(:user) do
    create :user, :completed_profile, first_name: "Test User john"
  end

  let!(:form_answer) do
    create :form_answer, :innovation,
                         user: user,
                         urn: "QA0001/19T",
                         document: { company_name: "Bitzesty" }
  end

  let!(:basic_eligibility) do
    create :basic_eligibility, form_answer: form_answer,
                               account: user.account
  end

  let!(:innovation_eligibility) do
    create :innovation_eligibility, form_answer: form_answer,
                                    account: user.account
  end

  let!(:trade_eligibility) do
    create :trade_eligibility, form_answer: form_answer,
                               account: user.account
  end

  let!(:development_eligibility) do
    create :development_eligibility, form_answer: form_answer,
                                     account: user.account
  end

  before do
    login_admin(admin)

    visit admin_form_answers_path
    visit review_admin_form_answer_path(form_answer)
  end

  describe "Review" do
    it "I should be logged as form answer owner and form should be in 'read only' mode" do
      expect(page.current_path).to eq edit_form_path(form_answer)

      expect(find_field('form[company_name]', disabled: true).value).to eq('Bitzesty')
    end
  end
end
