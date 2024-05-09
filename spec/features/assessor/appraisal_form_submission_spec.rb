require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "Assessor submits appraisal form", %(
  As Assessor
  I want to be able to edit, submit the appraisal form.
), js: true do
  let(:scope) { :assessor }
  let(:subject) { create(:assessor, :lead_for_all) }

  it_behaves_like "successful appraisal form edition"

  describe "Form submission" do
    let!(:form_answer) { create(:form_answer, :trade) }

    before do
      login_as(subject, scope: scope)
      visit assessor_form_answer_path form_answer
    end

    it "submits the form" do
      allow_any_instance_of(AssessorAssignment).to receive(:valid?).and_return(true)

      find("#appraisal-form-primary-heading .panel-title a").click

      take_a_nap

      within "#section-appraisal-form-primary" do
        click_button "Submit appraisal"
      end

      visit assessor_form_answer_path form_answer

      expect(form_answer.assessor_assignments.primary).to be_submitted
    end
  end
end
