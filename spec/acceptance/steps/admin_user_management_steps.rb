step "I go to user management page" do
  visit '/admin/users'
end

step "I create new user" do
  step "I go to user management page"
  click_link "+ Add applicant"

  fill_in 'Email', with: 'user@example.com'
  select "Regular", from: "Account type"

  click_button "Save"
end

step "I edit user" do
  step "I go to user management page"
  find(".link-edit-user").click

  fill_in 'Email', with: 'user@example.com'

  click_button "Save"
end

step "I should see user in the list" do
  step "I go to user management page"

  expect(page).to have_link('user@example.com')
end

step "a not confirmed user exists" do
  @not_confirmed_user = FactoryBot.create(:user, confirmed_at: nil, password: "my98ssdkjv9823kds=2")
end

step "a locked user exists" do
  @locked_user = FactoryBot.create(:user, password: "my98ssdkjv9823kds=2")
  @locked_user.lock_access!
end

step "I am on confirmed user page" do
  visit "/admin/users/#{@user.id}/edit"
end

step "I dont see resend confirmation link" do
  expect(page).to have_no_link('Resend confirmation email')
end

step "I am on not confirmed user page" do
  visit "/admin/users/#{@not_confirmed_user.id}/edit"
end

step "I am on locked user page" do
  visit "/admin/users/#{@locked_user.id}/edit"
end

step "I see resend confirmation link" do
  expect(page).to have_link('Resend confirmation email')
end

step "I see unlock user link" do
  expect(page).to have_link('Unlock')
end

step "I do resend confirmation instructions" do
  click_link 'Resend confirmation email'
end

step "I do unlock of user" do
  click_link 'Unlock'
end

step "I should see flash message about confirmation email sending" do
  expect_to_see "Confirmation instructions were successfully sent to #{@not_confirmed_user.decorate.full_name} (#{@not_confirmed_user.email})"
end

step "I should see flash message about unlocked access for user" do
  expect_to_see "User #{@locked_user.decorate.full_name} (#{@locked_user.email}) successfully unlocked!"
end

step "user should be unlocked" do
  expect(@locked_user.reload.access_locked?).to be_falsey
end
