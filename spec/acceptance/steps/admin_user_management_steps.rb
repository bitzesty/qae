step "I go to user management page" do
  visit '/admin/users'
end

step "I create new user" do
  step "I go to user management page"
  click_link 'New user'

  fill_in 'Email', with: 'user@example.com'
  select 'Regular', from: "Account type"
  fill_in 'Password', with: "my98ssdkjv9823kds=2"
  fill_in 'Password confirmation', with: "my98ssdkjv9823kds=2"

  click_button 'Create User'
end

step "I edit user" do
  step "I go to user management page"
  find(".link-edit-user").click

  fill_in 'Email', with: 'user@example.com'

  click_button 'Update User'
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
