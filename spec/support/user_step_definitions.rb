module UserStepDefinitions
  def login_admin(admin)
    visit '/admins/sign_in'
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: 'strongpass'
    click_button 'Log in' 
  end
end
