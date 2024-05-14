require "rails_helper"

RSpec.describe Admin::EmailNotificationsController do
  let!(:admin) { create(:admin, superadmin: true) }
  let!(:email_notification) { create(:email_notification) }
  before do
    sign_in admin
  end

  describe "POST create" do
    it "should create a resource" do
      post :create, params: { email_notification: FactoryBot.attributes_for(:email_notification, formatted_trigger_at_date: Date.current.strftime("%d/%m/%Y"), formatted_trigger_at_time: "1:00") }
      expect(response).to redirect_to admin_settings_path
      expect(EmailNotification.count).to eq 2
    end

    it "should render show" do
      post :create, params: { email_notification: FactoryBot.attributes_for(:email_notification, formatted_trigger_at_date: nil) }
      expect(response).to render_template("show")
      expect(EmailNotification.count).to eq 1
    end
  end

  describe "PUT update" do
    it "should update a resource" do
      put :update, params: { id: email_notification.id, email_notification: { kind: "unsuccessful_notification" } }
      expect(response).to redirect_to admin_settings_path
      expect(EmailNotification.first.kind).to eq "unsuccessful_notification"
    end
  end

  describe "Delete destroy" do
    it "should destroy a resource" do
      delete :destroy, params: { id: email_notification.id }
      expect(response).to redirect_to admin_settings_path
      expect(EmailNotification.count).to eq 0
    end
  end
end
