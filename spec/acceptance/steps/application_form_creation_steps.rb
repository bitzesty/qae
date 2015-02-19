step "an eligible user exists" do
  @user = FactoryGirl.create(:user, :eligible, password: 'password123')
end

step "I am eligible user" do
  step "an eligible user exists"
  step "I sign in as user"
end

step "I go to dashboard" do
  visit '/dashboard'
end

step "I should see innovation application link" do
  expect(page).to have_link("New application", href:'/apply_innovation_award')
end

step "I should see international trade application link" do
  expect(page).to have_link("New application", href:'/apply_international_trade_award')
end

step "I should see sustainable development application link" do
  expect(page).to have_link("New application", href:'/apply_sustainable_development_award')
end

step "I create innovation form" do
  step "I go to dashboard"
  click_link "New application", href: '/apply_innovation_award'
  click_link "Start application", href: '/new_innovation_form'
  click_button "Continue" #eligibility step
end

step "I create international trade form" do
  step "I go to dashboard"
  click_link "New application", href: '/apply_international_trade_award'
  click_link "Start application", href: '/new_international_trade_form'
  click_button "Continue" #eligibility step
end

step "I create sustainable development form" do
  step "I go to dashboard"
  click_link "New application", href: '/apply_sustainable_development_award'
  click_link "Start application", href: '/new_sustainable_development_form'
  click_button "Continue" #eligibility step
end

step "I should see qae form" do
  have_selector "form.qae_form"
end

step "I should see application edit link on dashboard" do
  step "I go to dashboard"
  expect(page).to have_link("Continue application")
end
