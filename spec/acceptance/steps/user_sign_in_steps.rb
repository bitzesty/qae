step "a user exists" do
  @user = FactoryBot.create(:user, password: "my98ssdkjv9823kds=2")
end

step "an account user exists" do
  FactoryBot.create(:user, password: "my98ssdkjv9823kds=2", role: "regular", account: @user.account)
end

step "Account admin user exists" do
  @user = FactoryBot.create(:user, password: "my98ssdkjv9823kds=2", role: "account_admin")
end

step "I sign in as user" do
  visit "/users/sign_in"

  fill_in "user_email", with: @user.email
  fill_in "user_password", with: "my98ssdkjv9823kds=2"
  click_button "Sign in"
end

step "I am account admin user" do
  step "Account admin user exists"
  step "I sign in as user"
end
