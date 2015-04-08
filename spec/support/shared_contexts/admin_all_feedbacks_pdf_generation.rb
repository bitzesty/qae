require 'rails_helper'

shared_context "admin all feedbacks pdf generation" do
  let!(:form_answer) do
    create :form_answer, award_type,
                         :submitted
  end

  let!(:feedback) do
    create :feedback, form_answer: form_answer,
                      document: feedback_document(award_type),
                      submitted: true
  end

  let(:pdf_filename) do
    "#{FormAnswer::AWARD_TYPE_FULL_NAMES[award_type]}_award_feedbacks"
  end

  describe "Download PDF" do
    before do
      visit download_feedbacks_pdf_admin_reports_path(category: award_type, format: :pdf)
    end

    it "should generate pdf" do
      expect(page.status_code).to eq(200)
      expect(page.response_headers["Content-Disposition"]).to include pdf_filename
      expect(page.response_headers["Content-Type"]).to be_eql "application/pdf"
    end
  end

  def feedback_document(award_type)
    res = {}

    FeedbackForm.fields_for_award_type(award_type).each do |key, value|
      res["#{key}_strength"] = "#{key} strength"
      res["#{key}_weakness"] = "#{key} weakness"
    end

    res
  end
end
