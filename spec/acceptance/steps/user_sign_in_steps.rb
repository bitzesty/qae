step "a user exists" do
  @user = FactoryGirl.create(:user, password: 'password123')
end

step "an account user exists" do
  FactoryGirl.create(:user, password: 'password123', role: 'regular', account: @user.account)
end

step "Account admin user exists" do
  @user = FactoryGirl.create(:user, password: 'password123', role: 'account_admin')
end

step "I sign in as user" do
  visit '/users/sign_in'

  fill_in 'user_email', with: @user.email
  fill_in 'user_password', with: 'password123'
  click_button 'Log in'
end

step "I am account admin user" do
  step "Account admin user exists"
  step "I sign in as user"
end
