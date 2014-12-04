step "I go to user management page" do
  if @admin
    visit '/admin/users'
  else
    visit '/account/users'
  end
end

step "I create new user" do
  step "I go to user management page"
  click_link 'Create user'

  fill_in 'Email', with: 'user@example.com'
  select 'Regular', from: 'Role'
  fill_in 'Password', with: 'strongpass'
  fill_in 'Password confirmation', with: 'strongpass'

  click_button 'Create User'
end

step "I edit user" do
  step "I go to user management page"

  click_link 'Edit'

  fill_in 'Email', with: 'user@example.com'

  click_button 'Update User'
end

step "I delete user" do
  step "I go to user management page"

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
