require "rails_helper"

RSpec.describe Admin::AdminsController do
  let!(:admin) { create(:admin, superadmin: true) }
  before do
    sign_in admin
  end

  describe "GET index" do
    it "assigns @resources" do
      get :index
      expect(assigns(:resources)).to eq([admin])
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
      post :create, params: { admin: FactoryBot.attributes_for(:admin) }
      expect(response).to redirect_to admin_admins_url
      expect(Admin.count).to eq 2
    end
  end
  describe "GET edit" do
    it "renders the  template" do
      get :edit, params: { id: admin.id }
      expect(response).to render_template("edit")
    end
  end

  describe "PUT update" do
    it "should update a resource" do
      put :update, params: { id: admin.id, admin: { first_name: "changed first name" } }
      expect(response).to redirect_to admin_admins_url
      expect(Admin.first.first_name).to eq "changed first name"
    end
  end

  describe "Delete destroy" do
    it "should destroy a resource" do
      to_be_deleted = create(:admin)
      delete :destroy, params: { id: to_be_deleted.id }
      expect(response).to redirect_to admin_admins_url
      expect(Admin.count).to eq 1
    end
  end

  describe "GET login_as_assessor" do
    it "should login_as_assessor" do
      assessor = create(:assessor)
      get :login_as_assessor, params: { email: assessor.email }
      expect(response).to redirect_to assessor_root_path
    end
  end

  describe "GET login_as_user" do
    it "should login_as_user" do
      user = create(:user)
      get :login_as_user, params: { email: user.email }
      expect(response).to redirect_to dashboard_url
    end
  end
end
