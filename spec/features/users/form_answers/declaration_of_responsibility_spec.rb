require "rails_helper"
include Warden::Test::Helpers

describe "Corporate Responsibility Form" do
  let(:user) do
    create :user
  end

  let!(:form_answer) do
    create :form_answer, :innovation, user: user
  end

  before do
    login_as user
  end

  it "saves responsibility" do
    visit edit_users_form_answer_declaration_of_responsibility_path(form_answer)

    [
      :impact_on_society,
      :impact_on_environment,
      :partners_relations,
      :employees_relations,
      :customers_relations
    ].each_with_index do |attr, index|
      fill_in attr.to_s.humanize, with: index
    end

    click_button "Submit Declaration"

    expect(page).to have_content "Declaration of corporate responsibility was successfully submitted"
  end
end
