require "rails_helper"
include Warden::Test::Helpers

RSpec.describe Admin::SupportLettersController do
  let!(:admin) { create(:admin, superadmin: true) }
  let!(:form_answer) { create(:form_answer) }
  let!(:support_letter) { create(:support_letter, form_answer:) }

  before do
    sign_in admin
  end

  describe "GET show" do
    it "check  status" do
      get :show, params: { form_answer_id: form_answer.id, id: support_letter.id }
      expect(response.code).to eq "200"
      expect(response).to render_template("admin/support_letters/show")
    end
  end
end
