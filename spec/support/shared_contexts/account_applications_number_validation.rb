shared_context "account applications number validation" do
  it "returns false when there is no award" do
    expect(account.reload.has_award_in_this_year?(award_type)).to be_falsey
  end

  it "returns false when there is award, but for previous year" do
    create(:form_answer, award_type, user:, award_year: previous_year)
    expect(account.reload.has_award_in_this_year?(award_type)).to be_falsey
  end

  it "returns true when there is a award for current year" do
    create(:form_answer, award_type, user:, award_year: current_year)
    expect(account.reload.has_award_in_this_year?(award_type)).to be_truthy
  end
end
