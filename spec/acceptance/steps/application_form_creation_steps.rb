step "an eligible user exists" do
  @user = FactoryBot.create(:user, :eligible, password: "my98ssdkjv9823kds=2")
end

step "settings with submission deadlines exists" do
  AwardYear.current # init a new instance
  FactoryBot.create(:settings, :submission_deadlines)
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
  click_button "Save and start eligibility questionnaire"
  click_link "Continue to eligibility questions"
  click_button "Continue" #eligibility step
end

step "I create international trade form" do
  step "I go to dashboard"
  click_link "New application", href: '/apply_international_trade_award'
  click_button "Start eligibility questionnaire"
  click_link "Continue to eligibility questions"
  click_button "Continue" #eligibility step
end

step "I create sustainable development form" do
  step "I go to dashboard"
  click_link "New application", href: '/apply_sustainable_development_award'
  click_button "Start eligibility questionnaire"
  click_link "Continue to eligibility questions"
  click_button "Continue" #eligibility step
end

step "I should see qae form" do
  have_selector "form.qae_form"
end

step "I should see application edit link on dashboard" do
  step "I go to dashboard"
  expect(page).to have_link("Continue application")
end
