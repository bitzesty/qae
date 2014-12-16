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
    FactoryGirl.create :eligibility, :basic, :passed, form_answer: form_answer,
                                                                    user: user
  end

  let!(:innovation_eligibility) do
    FactoryGirl.create :eligibility, :innovation, :passed, form_answer: form_answer,
                                                           user: user
  end

  let!(:trade_eligibility) do
    FactoryGirl.create :eligibility, :trade, :passed, form_answer: form_answer,
                                                      user: user
  end 

  let!(:development_eligibility) do
    FactoryGirl.create :eligibility, :development, :passed, form_answer: form_answer,
                                                            user: user
  end

  before do
    login_admin(admin)

    visit admin_form_answers_path
    click_link "Review"
  end

  describe "Review" do
    it "I should be logged as form answer owner and form should be in 'read only' mode", js: true do
      expect(page.current_path).to eq edit_form_path(form_answer)
      
      company_name = page.evaluate_script("$('input[name=\"company_name\"]').val();")
      expect(company_name).to eq("Bitzesty")

      disabled = page.evaluate_script("$('input[name=\"company_name\"]').is(':disabled');")
      expect(disabled).to eq(true)
    end
  end
end