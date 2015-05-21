require 'rails_helper'

shared_context "admin all case summaries pdf generation" do
  let!(:form_answer) do
    create :form_answer, award_type,
                         :submitted
  end

  let!(:assessor_assignment) do
    create :assessor_assignment, form_answer: form_answer,
                                 submitted_at: Date.today,
                                 assessor: nil,
                                 position: "primary_case_summary",
                                 document: assessor_assignment_document
  end

  let(:assessor_assignment_document) do
    res = {}

    AppraisalForm.struct(form_answer).each do |key, value|
      res["#{key}_desc"] = "Lorem Ipsum"
      res["#{key}_rate"] = ["negative", "positive", "average"].sample
    end

    res
  end

  let(:pdf_filename) do
    "#{FormAnswer::AWARD_TYPE_FULL_NAMES[award_type]}_case_summaries"
  end

  describe "Download PDF" do
    before do
      visit admin_report_path("case_summaries", category: award_type, format: :pdf)
    end

    it "should generate pdf" do
      expect(page.status_code).to eq(200)
      expect(page.response_headers["Content-Disposition"]).to include pdf_filename
      expect(page.response_headers["Content-Type"]).to be_eql "application/pdf"
    end
  end
end
