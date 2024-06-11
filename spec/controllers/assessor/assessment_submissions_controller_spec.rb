require "rails_helper"

RSpec.describe Assessor::AssessmentSubmissionsController do
  let!(:assessor) { create(:assessor) }
  let!(:assessor_assignment) { create(:assessor_assignment) }

  before do
    sign_in assessor
    allow_any_instance_of(Assessor).to receive(:lead?) { true }
    allow_any_instance_of(AssessorAssignment).to receive(:locked?) { true }
  end

  describe "POST create" do
    it "should create a resource" do
      allow_any_instance_of(AssessmentSubmissionService).to receive(:perform) {}
      post :create, params: { assessment_id: assessor_assignment.id }
      expect(response).to redirect_to [:assessor, assessor_assignment.form_answer]

      post :create, params: { assessment_id: assessor_assignment.id }, format: :json
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end
  end

  describe "PATCH unlonk" do
    it "should unlock a resource" do
      patch :unlock, params: { id: assessor_assignment.id, assessment_id: assessor_assignment.id }
      expect(response).to redirect_to [:assessor, assessor_assignment.form_answer]
      expect(assessor_assignment.reload.locked_at).to be_nil
    end
  end
end
