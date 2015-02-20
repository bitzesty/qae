require 'rails_helper'
include Warden::Test::Helpers

describe 'Admin notifications confirmation', %q{
  As Admin
  I want to see confirmation before triggering notifications to users
} do

  let!(:admin){ create(:admin)}

  before do
    login_admin admin
    visit admin_dashboard_index_path
  end

  context 'confirms notification' do
    it 'confirms notification to shortlisted users' do
      click_link 'Trigger notification to shortlisted'
      fill_in 'confirmation_confirmation', with: 'yes'
      click_button 'Confirm'

      expect(page).to have_content('Shortlisted users were successfully notified')
    end

    it 'confirms notification to non-shortlisted users' do
      click_link 'Trigger notification to non-shortlisted'
      fill_in 'confirmation_confirmation', with: 'yes'
      click_button 'Confirm'

      expect(page).to have_content('Non-shortlisted users were successfully notified')
    end
  end

  context 'does not confirm notification' do
    it 'does not confirm notification to shortlisted users' do
      click_link 'Trigger notification to shortlisted'
      fill_in 'confirmation_confirmation', with: 'test'
      click_button 'Confirm'

      expect(page).to have_content('Action was not confirmed')
    end

    it 'does not confirm notification to non-shortlisted users' do
      click_link 'Trigger notification to non-shortlisted'
      fill_in 'confirmation_confirmation', with: 'test'
      click_button 'Confirm'

      expect(page).to have_content('Action was not confirmed')
    end
  end
end
