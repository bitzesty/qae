step "Admin user exists" do
  @admin = FactoryBot.create(:admin)
end

step "I sign in as admin" do
  login_admin(@admin)
end

step "I should see sign out link" do
  expect(page).to have_selector(:link_or_button, "Sign out")
end

step "I am admin user" do
  step "Admin user exists"
  step "I sign in as admin"
end
