require 'spec_helper'
include Warden::Test::Helpers

describe "Review 'read only' version of the form", %q{
As a Admin
I want to be able to see the forms (read only) but exactly as the user filling it in would see it
So that I can have 'read only' version of form
} do

  let!(:admin) do
    FactoryGirl.create(:admin)
  end

  let!(:user) do
    FactoryGirl.create :user, :completed_profile, first_name: "Test User john"
  end

  let!(:form_answer) do
    FactoryGirl.create :form_answer, :innovation,
                                     user: user,
                                     urn: "QA0001/19T",
                                     document: { company_name: "Bitzesty" }
  end

  let!(:basic_eligibility) do
    FactoryGirl.create :basic_eligibility, form_answer: form_answer,
                                           user: user
  end

  let!(:innovation_eligibility) do
    FactoryGirl.create :innovation_eligibility, form_answer: form_answer,
                                                user: user
  end

  let!(:trade_eligibility) do
    FactoryGirl.create :trade_eligibility, form_answer: form_answer,
                                           user: user
  end

  let!(:development_eligibility) do
    FactoryGirl.create :development_eligibility, form_answer: form_answer,
                                                 user: user
  end

  before do
    login_admin(admin)

    visit admin_form_answers_path
    click_link "Review"
  end

  describe "Review" do
    it "I should be logged as form answer owner and form should be in 'read only' mode" do
      expect(page.current_path).to eq edit_form_path(form_answer)

      expect(find_field('form[company_name]', disabled: true).value).to eq('Bitzesty')
    end
  end
end
