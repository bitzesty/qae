step "a form answer exists" do
  FactoryGirl.create(:form_answer)
end

step "a withdrawn form answer exists" do
  FactoryGirl.create(:form_answer, withdrawn: true)
end

step "I withdraw form answer" do
  visit "/admin/form_answers"
  click_link "Withdraw"
end

step "form answer should be withdrawn" do
  expect(page).to have_link("Restore")
end

step "I restore form answer" do
  visit "/admin/form_answers"
  click_link "Restore"
end

step "form answer should not be withdrawn" do
  expect(page).to have_link("Withdraw")
end
