require "rails_helper"
include Warden::Test::Helpers

RSpec.describe Admin::AssessmentSubmissionsController do
  let!(:admin) {create(:admin, superadmin: true)}
  let!(:assessor_assignment) { create(:assessor_assignment) }

  before do
    sign_in admin
    allow_any_instance_of(AssessorAssignment).to receive(:locked?) {true}
  end

  describe "POST create" do
    it "should create a resource" do
      allow_any_instance_of(AssessmentSubmissionService).to receive(:perform) {}
      post :create, params: { assessment_id: assessor_assignment.id }
      expect(response).to redirect_to [:admin, assessor_assignment.form_answer]

      post :create, params: { assessment_id: assessor_assignment.id }, format: :json
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end
  end

  describe "PATCH unlock" do
    let(:form_answer) { assessor_assignment.form_answer }

    context "primary assessment" do
      let!(:assessor_assignment) { create(:assessor_assignment, position: "primary", locked_at: Time.now) }

      before do
        form_answer.update_column(:state, "recommended")
      end

      it "should unlock a resource" do
        patch :unlock, params: { id: assessor_assignment.id, assessment_id: assessor_assignment.id }
        expect(response).to redirect_to [:admin, assessor_assignment.form_answer]
        expect(form_answer.reload.state).to eq("recommended")
        expect(assessor_assignment.reload.locked_at).to be_nil
      end
    end

    context "secondary assessment" do
      let!(:assessor_assignment) { create(:assessor_assignment, :submitted, :locked, position: "secondary") }

      before do
        assessor_assignment.form_answer.update_column(:state, "recommended")
      end

      it "should unlock a resource" do
        patch :unlock, params: { id: assessor_assignment.id, assessment_id: assessor_assignment.id }
        expect(response).to redirect_to [:admin, assessor_assignment.form_answer]
        expect(form_answer.reload.state).to eq("recommended")
        expect(assessor_assignment.reload.locked_at).to be_nil
      end
    end

    context "moderated assessment" do
      let!(:assessor_assignment) { create(:assessor_assignment, :submitted, :locked, position: "moderated") }

      before do
        assessor_assignment.form_answer.update_column(:state, "recommended")
      end

      it "should unlock a resource" do
        patch :unlock, params: { id: assessor_assignment.id, assessment_id: assessor_assignment.id }
        expect(response).to redirect_to [:admin, assessor_assignment.form_answer]
        expect(form_answer.reload.state).to eq("assessment_in_progress")
        expect(assessor_assignment.reload.locked_at).to be_nil
      end
    end

    context "case summary" do
      let!(:assessor_assignment) { create(:assessor_assignment, :submitted, :locked, position: "case_summary") }

      before do
        assessor_assignment.form_answer.update_column(:state, "recommended")
      end

      it "should unlock a resource" do
        patch :unlock, params: { id: assessor_assignment.id, assessment_id: assessor_assignment.id }
        expect(response).to redirect_to [:admin, assessor_assignment.form_answer]
        expect(form_answer.reload.state).to eq("recommended")
        expect(assessor_assignment.reload.locked_at).to be_nil
      end
    end
  end
end
