require "rails_helper"

describe Admin::AdminsController do
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
