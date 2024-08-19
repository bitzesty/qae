require "rails_helper"

describe "Admin assigns the primary and secondary assessors" do
  let!(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer) }
  let!(:assessor) { create(:assessor, :lead_for_all) }

  before do
    login_admin(admin)
  end

  context "with no assessors assigned" do
    before do
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

  context "primary assessor already assigned" do
    before do
      primary = form_answer.assessor_assignments.primary
      primary.assessor_id = assessor.id
      primary.save!
      visit admin_form_answer_path(form_answer)
    end

    it "removes the primary assessor" do
      within ".section-applicant-users" do
        first("option").select_option
        first("input.form-save-button[type='submit']").click
      end
      expect(form_answer.reload.assessors.primary).to be_blank
    end
  end

  context "secondary assessor already assigned" do
    before do
      secondary = form_answer.assessor_assignments.secondary
      secondary.assessor_id = assessor.id
      secondary.save!
      visit admin_form_answer_path(form_answer)
    end

    it "removes the secondary assessor" do
      within ".secondary-assessor-assignment" do
        first("option").select_option
        all("input.form-save-button[type='submit']").last.click
      end

      expect(form_answer.reload.assessors.secondary).to be_blank
    end
  end
end
