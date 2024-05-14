require "rails_helper"

RSpec.describe Assessor::ReportsController do
  let!(:assessor) { create(:assessor) }
  let!(:form_answer) { create(:form_answer) }

  before do
    sign_in assessor
    allow_any_instance_of(Assessor).to receive(:lead_for_any_category?) { true }
  end

  describe "GET index" do
    it "should render template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET show" do
    it "renders the show template" do
      get :show, params: { id: "feedbacks", category: "trade" }, format: "pdf"
      expect(response.content_type).to eq("application/pdf")

      get :show, params: { id: "case_summaries", category: "trade" }, format: "csv"
      expect(response.content_type).to eq("text/csv")
    end
  end
end
