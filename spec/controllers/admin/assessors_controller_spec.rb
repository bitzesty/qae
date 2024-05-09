require "rails_helper"
include Warden::Test::Helpers

RSpec.describe Admin::AssessorsController do
  let!(:admin) { create(:admin, superadmin: true) }
  let!(:assessor) { create(:assessor) }
  before do
    sign_in admin
  end

  describe "GET index" do
    it "assigns @resources" do
      get :index
      expect(assigns(:resources)).to eq([assessor])
      expect(response).to render_template("index")
    end
  end

  describe "GET new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "POST create" do
    it "should create a resource" do
      post :create, params: { assessor: FactoryBot.attributes_for(:assessor) }
      expect(response).to redirect_to admin_assessors_url
      expect(Assessor.count).to eq 2
    end
  end
  describe "GET edit" do
    it "renders the  template" do
      get :edit, params: { id: assessor.id }
      expect(response).to render_template("edit")
    end
  end

  describe "PUT update" do
    it "should update a resource" do
      put :update, params: { id: assessor.id, assessor: { first_name: "changed first name" } }
      expect(response).to redirect_to admin_assessors_url
      expect(Assessor.first.first_name).to eq "changed first name"
    end
  end

  describe "Delete destroy" do
    it "should destroy a resource" do
      delete :destroy, params: { id: assessor.id }
      expect(response).to redirect_to admin_assessors_url
      expect(Assessor.count).to eq 0
    end
  end
end
