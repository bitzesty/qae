step "a user exists" do
  @user = FactoryGirl.create(:user, password: 'password123')
end

step "I sign in as user" do
  visit '/users/sign_in'

  fill_in 'user_email', with: @user.email
  fill_in 'user_password', with: 'password123'
  click_button 'Log in'
end
