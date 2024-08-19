require "rails_helper"

RSpec.describe Assessor::CommentsController do
  let!(:assessor) { create(:assessor) }
  let!(:form_answer) { create(:form_answer) }
  let!(:comment) { create(:comment, section: 1, commentable: form_answer) }

  before do
    sign_in assessor
    allow_any_instance_of(Assessor).to receive(:lead?) { true }
  end

  describe "POST create" do
    it "should create a resource" do
      post :create, params: { form_answer_id: form_answer.id, comment: FactoryBot.attributes_for(:comment, section: "critical") }
      expect(response).to redirect_to assessor_form_answer_path(form_answer)
      expect(Comment.count).to eq 2
    end
  end

  describe "PUT update" do
    it "should update a resource" do
      put :update, params: { id: comment.id, form_answer_id: form_answer.id, comment: { flagged: false } }
      expect(response).to redirect_to assessor_form_answer_path(form_answer)
      expect(Comment.first.flagged).to be_falsey
    end
  end

  describe "Delete destroy" do
    it "should destroy a resource" do
      allow_any_instance_of(Comment).to receive(:author?) { true }
      delete :destroy, params: { id: comment.id, form_answer_id: form_answer.id }
      expect(response).to redirect_to assessor_form_answer_path(form_answer)
      expect(Comment.count).to eq 0
    end
  end
end
