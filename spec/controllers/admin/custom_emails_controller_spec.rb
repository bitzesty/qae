require "rails_helper"
include Warden::Test::Helpers

RSpec.describe Admin::CustomEmailsController do
  let!(:admin) {create(:admin, superadmin: true)}
  before do
    sign_in admin
  end

  describe "GET show" do
    it "renders the show template" do
      get :show
      expect(assigns(:form).present?).to be_truthy
      expect(response).to render_template("show")
    end
  end

  describe "POST create" do
    it "should create a message" do
      post :create, params: { custom_email_form: { message: "test", scope: "myself", subject: "test" } }
      expect(response).to redirect_to admin_custom_email_path
      post :create, params: { custom_email_form: { message: "test", scope: "myself", subject: "test" } }
      expect(response).to redirect_to admin_custom_email_path
    end
    it "should render show" do
      post :create, params: { custom_email_form: { } }
      expect(response).to render_template("show")
    end
  end
end
