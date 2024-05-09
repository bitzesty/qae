require "rails_helper"

RSpec.describe SupportLettersController, type: :controller do
  context "access key check" do
    let!(:user) { create(:user) }
    let!(:form_answer) { create(:form_answer, user: user) }
    let!(:supporter) do
      create :supporter, form_answer: form_answer,
        user: user
    end

    it "renders 404 if access key is invalid" do
      get :show, params: { access_key: "hack" }

      expect(response.status).to eq(404)
    end

    it "renders 200 if access key is valid" do
      get :show, params: { access_key: supporter.access_key }

      expect(response.status).to eq(200)
    end
  end
end
