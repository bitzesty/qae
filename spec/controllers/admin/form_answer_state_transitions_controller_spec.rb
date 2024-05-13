require "rails_helper"
include Warden::Test::Helpers

RSpec.describe Admin::FormAnswerStateTransitionsController do
  let!(:admin) { create(:admin, superadmin: true) }
  let!(:form_answer) { create(:form_answer) }

  before do
    sign_in admin
    allow_any_instance_of(AssessorAssignment).to receive(:locked?) { true }
  end

  describe "POST create" do
    it "should create a resource" do
      allow_any_instance_of(AssessmentSubmissionService).to receive(:perform) {}
      post :create, params: {
        form_answer_id: form_answer.id,
        form_answer_state_transition: { state: "recommended" },
      }

      expect(response).to redirect_to [:admin, form_answer]

      post :create, params: {
        form_answer_id: form_answer.id,
        form_answer_state_transition: { state: "recommended" },
      }, xhr: true

      expect(response).to render_template(:partial => "admin/form_answers/_states_list")
    end
  end
end
