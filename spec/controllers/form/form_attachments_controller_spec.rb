require "rails_helper"
include Warden::Test::Helpers

RSpec.describe Form::FormAttachmentsController do
  let!(:user) { create(:user) }

  let!(:form_answer) { create :form_answer, user: user }
  let!(:form_answer_attachment) { create :form_answer_attachment, form_answer: form_answer }

  before do
    sign_in user
    # allow(controller).to receive(:step).and_return(double(title: 'test'))
    # allow(controller).to receive(:question).and_return(double({}))
    # allow(controller).to receive(:categories).and_return([double(value: 'test')])
    # allow(controller).to receive(:years).and_return([2018])
    # allow(controller).to receive(:outcomes).and_return([double(text: 'test', value: 'value')])
  end

  describe "GET new" do
    it "renders the new template" do
      get :new, params: { form_answer_id: form_answer.id }
      expect(response).to render_template("new")
    end
  end
  describe "GET index" do
    it "renders the index template" do
      get :index, params: { form_answer_id: form_answer.id }
      expect(response).to render_template("index")
    end
  end

  describe "POST create" do
    it "should create a resource" do
      allow_any_instance_of(FormAnswerAttachment).to receive(:save) { true }
      post :create, params: { form_answer_id: form_answer.id, form_answer_attachment: { description: "title" } }
      expect(response).to redirect_to redirect_to edit_form_url(form_answer, step: "supplementary-materials-confirmation")
      expect(form_answer.reload.document.present?).to be_truthy
    end
  end

  describe "Delete destroy" do
    it "should destroy a resource" do
      delete :destroy, params: { id: form_answer_attachment.id, form_answer_id: form_answer.id }
      expect(response).to redirect_to redirect_to edit_form_url(form_answer, step: "supplementary-materials-confirmation")
      expect(form_answer.reload.document.present?).to be_truthy
    end
  end
end
