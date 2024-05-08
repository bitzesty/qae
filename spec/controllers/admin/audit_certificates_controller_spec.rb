require "rails_helper"
include Warden::Test::Helpers

RSpec.describe Admin::AuditCertificatesController do
  let!(:admin) {create(:admin, superadmin: true)}
  let!(:form_answer) {create(:form_answer)}

  before do
    sign_in admin
  end

  describe "GET download_initial_pdf" do
    it "assigns @resources" do
      allow_any_instance_of(FormAnswer).to receive(:promotion?) {false}
      allow_any_instance_of(FormAnswer).to receive(:shortlisted?) {true}
      get :download_initial_pdf, params: { form_answer_id: form_answer.id }, :format => "pdf"
      expect(response.content_type).to eq("application/pdf")
    end
  end
end
