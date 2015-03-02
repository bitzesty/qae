require 'rails_helper'
include Warden::Test::Helpers

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
