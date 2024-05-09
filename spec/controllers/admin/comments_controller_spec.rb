require "rails_helper"
include Warden::Test::Helpers

RSpec.describe Admin::CommentsController do
  let!(:admin) { create(:admin, superadmin: true) }
  let!(:form_answer) { create(:form_answer) }
  let!(:comment) { create(:comment, section: 0, commentable: form_answer) }

  before do
    sign_in admin
  end

  describe "GET new" do
    it "renders the new template" do
      get :new, params: { form_answer_id: form_answer.id }
      expect(response).to render_template("new")
    end
  end

  describe "POST create" do
    it "should create a resource" do
      post :create, params: { form_answer_id: form_answer.id, comment: FactoryBot.attributes_for(:comment, section: "admin") }
      expect(response).to redirect_to admin_form_answer_path(form_answer)
      expect(Comment.count).to eq 2
    end
  end

  describe "PUT update" do
    it "should update a resource" do
      put :update, params: { id: comment.id, form_answer_id: form_answer.id, comment: { flagged: false } }
      expect(response).to redirect_to admin_form_answer_path(form_answer)
      expect(Comment.first.flagged).to be_falsey
    end
  end

  describe "Delete destroy" do
    it "should destroy a resource" do
      allow_any_instance_of(Comment).to receive(:author?) { true }
      delete :destroy, params: { id: comment.id, form_answer_id: form_answer.id }
      expect(response).to redirect_to admin_form_answer_path(form_answer)
      expect(Comment.count).to eq 0
    end
  end
end
