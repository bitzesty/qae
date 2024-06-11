require "rails_helper"

RSpec.describe Admin::SettingsController do
  let!(:admin) { create(:admin, superadmin: true) }
  before do
    sign_in admin
  end

  describe "GET index" do
    it "assigns @resources" do
      get :show
      expect(assigns(:email_notifications)).to eq []
      expect(response).to render_template("show")
    end
  end
end
