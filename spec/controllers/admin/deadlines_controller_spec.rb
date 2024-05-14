require "rails_helper"

RSpec.describe Admin::DeadlinesController do
  let!(:admin) { create(:admin, superadmin: true) }
  before do
    sign_in admin
  end

  describe "PUT update" do
    it "should update a resource" do
      deadline = create(:deadline)
      time = Time.current
      put :update, params: { id: deadline.id, deadline: { trigger_at: time } }
      expect(response).to redirect_to admin_settings_path
    end
  end
end
