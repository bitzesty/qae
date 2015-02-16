module UserStepDefinitions
  def login_admin(admin)
    visit '/admins/sign_in'
    fill_in 'admin_email', with: admin.email
    fill_in 'admin_password', with: 'strongpass'
    click_button 'Log in'
  end
end
