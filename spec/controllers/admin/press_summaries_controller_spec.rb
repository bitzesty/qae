require "rails_helper"

RSpec.describe Admin::PressSummariesController do
  let!(:admin) { create(:admin, superadmin: true) }
  let!(:form_answer) { create(:form_answer) }
  let!(:press_summary) { create(:press_summary, form_answer: form_answer) }

  before do
    sign_in admin
  end

  describe "POST create" do
    it "should create a resource" do
      press_summary.destroy
      post :create, params: { form_answer_id: form_answer.id, press_summary: FactoryBot.attributes_for(:press_summary) }
      expect(response).to redirect_to [:admin, form_answer]
      expect(PressSummary.count).to eq 1
    end
  end

  describe "PUT update" do
    it "should update a resource" do
      put :update, params: { id: press_summary.id, form_answer_id: form_answer.id, press_summary: { name: "changed  name" } }
      expect(response).to redirect_to [:admin, form_answer]
      expect(PressSummary.first.name).to eq "changed  name"
    end
  end

  describe "Post approve" do
    it "should approve a resource" do
      post :approve, params: { id: press_summary.id, form_answer_id: form_answer.id }
      expect(response).to redirect_to [:admin, form_answer]
      expect(press_summary.reload.approved?).to be_truthy
    end
  end
  describe "Post submit" do
    it "should submit a resource" do
      post :submit, params: { id: press_summary.id, form_answer_id: form_answer.id }
      expect(response).to redirect_to [:admin, form_answer]
      expect(press_summary.reload.submitted?).to be_truthy
    end
  end
  describe "Post unlock" do
    it "should unlock a resource" do
      allow_any_instance_of(PressSummaryPolicy).to receive(:unlock?) { true }
      post :unlock, params: { id: press_summary.id, form_answer_id: form_answer.id }
      expect(response).to redirect_to [:admin, form_answer]
      expect(press_summary.reload.submitted?).to be_falsey
    end
  end

  describe "Post signoff" do
    it "should signoff a resource" do
      allow_any_instance_of(PressSummaryPolicy).to receive(:admin_signoff?) { true }
      post :signoff, params: { id: press_summary.id, form_answer_id: form_answer.id }
      expect(response).to redirect_to [:admin, form_answer]
      expect(press_summary.reload.admin_sign_off?).to be_truthy
    end
  end
end
