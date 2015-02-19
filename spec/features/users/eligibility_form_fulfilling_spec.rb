require 'rails_helper'
include Warden::Test::Helpers

describe "Eligibility form fulfilling", %q{
As a User
I want to be able to check eligibility to awards
} do

  let!(:user){ create(:user, :completed_profile) }
  before{ login_as user }

  context 'after filling the eligibility form' do
    it 'sees the eligibility summary page' do
      fill_form_with_all_yes
      visit dashboard_path
      expect(page).to have_content('You are eligible to apply for:')

      eligible_awards = all('article li.eligible').map(&:text)
      expect(eligible_awards).to eq(['Innovation'])
    end
  end
end

def check_first_checkbox
  all(".question-body input[type='radio']:first").first.set(true)
end

def fill_form_with_all_yes
  visit new_innovation_form_path

  7.times do
    check_first_checkbox
    click_button 'Continue'
  end

  fill_in('eligibility_number_of_innovative_products', with: 1)
  click_button 'Continue'

  3.times do |i|
    check_first_checkbox
    click_button 'Continue'
  end
end
