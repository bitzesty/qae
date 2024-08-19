require "rails_helper"

shared_context "admin all case summaries pdf generation" do
  let!(:form_answer) do
    create :form_answer, award_type,
      :submitted
  end

  let!(:assessor_assignment) do
    create :assessor_assignment, form_answer: form_answer,
      submitted_at: Date.current,
      assessor: nil,
      position: "case_summary",
      document: assessor_assignment_document
  end

  let(:assessor_assignment_document) do
    res = {}

    ratings = %w[negative positive average]

    AppraisalForm.struct(form_answer).each do |key, values|
      res["#{key}_desc"] = "Lorem Ipsum"
      if values[:type] != :non_rag
        res["#{key}_rate"] = ratings.sample
      end
    end

    res
  end

  let(:pdf_filename) do
    "#{FormAnswer::AWARD_TYPE_FULL_NAMES[award_type]}_case_summaries"
  end

  describe "Download PDF" do
    before do
      ops = { category: award_type, format: :pdf }
      # For trade category it would have year depends links ('3 years' and '6 years')
      ops[:years_mode] = "3" if award_type == :trade

      visit admin_report_path("case_summaries", ops)
    end

    it "should generate pdf" do
      expect(page.status_code).to eq(200)
      expect(page.response_headers["Content-Disposition"]).to include pdf_filename
      expect(page.response_headers["Content-Type"]).to be_eql "application/pdf"
    end

    it "should create log entry" do
      log = AuditLog.last
      expect(log.subject).to eq(admin)
      expect(log.action_type).to eq("case_summaries")
    end
  end
end
