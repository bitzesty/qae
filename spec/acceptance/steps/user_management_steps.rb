step "I create new user" do
  visit '/admin/users'
  click_link 'Create user'

  fill_in 'Email', with: 'user@example.com'
  fill_in 'Password', with: 'strongpass'
  fill_in 'Password confirmation', with: 'strongpass'

  click_button 'Create User'
end

step "I edit user" do
  visit '/admin/users'
  click_link 'Edit'

  fill_in 'Email', with: 'user@example.com'

  click_button 'Update User'
end

step "I delete user" do
  visit '/admin/users'
  click_link 'Delete'
end

step "I should see user in the list" do
  visit '/admin/users'
  expect(page).to have_link('user@example.com')
end

step "I should not see user in the list" do
  visit '/admin/users'
  expect(page).to have_no_link('user@example.com')
end
