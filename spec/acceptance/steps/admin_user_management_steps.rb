step "I go to user management page" do
  visit '/admin/users'
end

step "I create new user" do
  step "I go to user management page"
  click_link "+ Add applicant"

  fill_in 'Email', with: 'user@example.com'
  select "Regular", from: "Account type"
  fill_in 'Password', with: "my98ssdkjv9823kds=2"
  fill_in 'Password confirmation', with: "my98ssdkjv9823kds=2"

  click_button "Save"
end

step "I edit user" do
  step "I go to user management page"
  find(".link-edit-user").click

  fill_in 'Email', with: 'user@example.com'

  click_button "Save"
end

step "I delete user" do
  step "I go to user management page"
  find(".link-edit-user").click

  click_link 'Delete'
end

step "I should see user in the list" do
  step "I go to user management page"

  expect(page).to have_link('user@example.com')
end

step "I should not see user in the list" do
  step "I go to user management page"

  expect(page).to have_no_link('user@example.com')
end

step "a not confirmed user exists" do
  @not_confirmed_user = FactoryGirl.create(:user, confirmed_at: nil, password: "my98ssdkjv9823kds=2")
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

step "I see resend confirmation link" do
  expect(page).to have_link('Resend confirmation email')
end

step "I do resend confirmation instructions" do
  click_link 'Resend confirmation email'
end

step "I should see flash message about confirmation email sending" do
  expect_to_see "Confirmation instructions were successfully sent to #{@not_confirmed_user.decorate.full_name} (#{@not_confirmed_user.email})"
end
