require "rails_helper"
include Warden::Test::Helpers

RSpec.describe Admin::AuditLogsController do
  let!(:admin) { create(:admin, superadmin: true) }
  before do
    sign_in admin
  end

  describe "GET index" do
    it "assigns @resources" do
      get :index
      expect(assigns(:audit_logs)).to eq([])
      expect(response).to render_template("index")
    end
  end
end
