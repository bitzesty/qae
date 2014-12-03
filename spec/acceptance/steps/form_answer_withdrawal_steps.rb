step "a form answer exists" do
  @form_answer = FactoryGirl.create(:form_answer)
end

step "I withdraw form answer" do
  visit "/admin/form_answers"
  click_link "Withdraw"
end

step "form answer should be withdrawn" do
  expect(@form_answer.reload).to be_withdrawn
end

step "I restore form answer" do
  visit "/admin/form_answers"
  click_link "Restore"
end

step "a form answer is withdrawn" do
  @form_answer.update!(withdrawn: true)
end

step "form answer should not be withdrawn" do
  expect(@form_answer.reload).to_not be_withdrawn
end
