step "Admin user exists" do
  @admin = FactoryGirl.create(:admin, password: 'password123')
end

step "I sign in as admin" do
  visit '/admins/sign_in'
  fill_in 'Email', with: @admin.email
  fill_in 'Password', with: 'password123'
  click_button 'Log in'
end

step "I should see sign out link" do
  expect(page).to have_link('Log out')
end

step "I am admin user" do
  step "Admin user exists"
  step "I sign in as admin"
end
