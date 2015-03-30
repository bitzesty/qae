require "rails_helper"

include Warden::Test::Helpers

describe "Admin assigns the primary and secondary assessors" do
  let!(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer) }
  let!(:assessor) { create(:assessor, :lead_for_all) }

  before do
    login_admin(admin)
    visit admin_form_answer_path(form_answer)
  end

  it "assigns the primary assessor" do
    within ".section-applicant-users" do
      first("option[value='#{assessor.id}']").select_option
      first("input.form-save-button[type='submit']").click
    end
    expect(form_answer.reload.assessors.primary).to eq(assessor)
  end

  it "assigns the secondary assessor" do
    within ".section-applicant-users" do
      all("option[value='#{assessor.id}']").last.select_option
      all("input.form-save-button[type='submit']").last.click
    end
    expect(form_answer.reload.assessors.secondary).to eq(assessor)
  end
end
