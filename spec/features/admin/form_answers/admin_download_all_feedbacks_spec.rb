require 'rails_helper'
include Warden::Test::Helpers

describe "Admin: Download all Feedbacks as one pdf", %q{
As an Admin
I want to download all Feedbacks as one pdf (all feedbacks) from Dashboard
So that I can print and review application feedbacks
} do

  let!(:admin) { create(:admin) }

  let!(:form_answer) do
    create :form_answer, :innovation,
                         :submitted
  end

  let(:feedback_content) do
    res = {}

    FeedbackForm.fields_for_award_type(form_answer.award_type).each do |key, value|
      res["#{key}_strength"] = "#{key} strength"
      res["#{key}_weakness"] = "#{key} weakness"
    end

    res
  end

  let!(:feedback) do
    create :feedback, form_answer: form_answer,
                      document: feedback_content,
                      submitted: true
  end

  let(:pdf_filename) do
    "application_feedbacks"
  end

  before do
    login_admin(admin)
  end

  describe "Download PDF" do
    before do
      visit download_feedbacks_pdf_admin_reports_path(format: :pdf)
    end

    it "should generate pdf" do
      expect(page.status_code).to eq(200)
      expect(page.response_headers["Content-Disposition"]).to be_eql "attachment; filename=\"#{pdf_filename}\""
      expect(page.response_headers["Content-Type"]).to be_eql "application/pdf"
    end
  end
end
