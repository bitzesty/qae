require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe Form::CurrentQueensAwardsController do
  let!(:user) {create(:user)}

  let!(:form_answer) {create :form_answer, user: user}


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
  describe "GET edit" do
    it "renders the edit template" do
      get :edit, params: { id: '000', form_answer_id: form_answer.id, current_queens_award: { category: 'title', year: Date.today.year } }
      expect(response).to render_template("edit")
    end
  end

  describe "POST create" do
    it "should create a resource" do
      allow_any_instance_of(CurrentQueensAward).to receive(:valid?) {true}
      post :create, params: { form_answer_id: form_answer.id, current_queens_award: { category: 'title', year: Date.today.year } }
      expect(response).to redirect_to edit_form_url(form_answer, step: "company-information", anchor: "non_js_applied_for_queen_awards_details-list-question")
      expect(form_answer.reload.document.present?).to be_truthy
    end
  end

  describe "PUT update" do
    it "should update a resource" do
      allow_any_instance_of(CurrentQueensAward).to receive(:valid?) {true}
      put :update, params: { id: '000', form_answer_id: form_answer.id, current_queens_award: { category: 'title2' } }
      expect(response).to redirect_to edit_form_url(form_answer, step: "company-information", anchor: "non_js_applied_for_queen_awards_details-list-question")
    end
  end

  describe "Delete destroy" do
    it "should destroy a resource" do
      delete :destroy, params: { id: '000', form_answer_id: form_answer.id }
      expect(response).to redirect_to edit_form_url(form_answer, step: "company-information", anchor: "non_js_applied_for_queen_awards_details-list-question")
      expect(form_answer.reload.document.present?).to be_truthy
    end
  end
end
