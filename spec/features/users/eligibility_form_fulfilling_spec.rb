require 'rails_helper'
include Warden::Test::Helpers

describe "Eligibility form fulfilling", %q{
As a User
I want to be able to check eligibility to awards
} do

  let!(:user){ create(:user) }
  before{ login_as user }

  context 'after filling the eligibility form' do
    it 'sees the eligibility summary page' do
      fill_form_with_all_yes

      expect(page).to have_content('You are eligible for:')

      eligible_awards = all('article li').first(2).map(&:text)

      expect(eligible_awards).to eq(['Innovation', 'Sustainable Development'])
    end
  end
end

def check_first_checkbox
  all(".question-body input[type='radio']:first").first.set(true)
end

def fill_form_with_all_yes
  visit root_path
  click_link 'Check eligibility'

  10.times do
    check_first_checkbox
    click_button 'Next step'
  end

  fill_in('eligibility_number_of_innovative_products', with: 1)
  click_button 'Next step'

  6.times do
    check_first_checkbox
    click_button 'Next step'
  end
end