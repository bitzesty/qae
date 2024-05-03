require "rails_helper"

shared_context "admin application case summaries pdf download" do
  let!(:form_answer) do
    create :form_answer, award_type,
           :recommended,
           user:
  end

  let!(:assessor_assignment) do
    create :assessor_assignment, form_answer:,
                                 submitted_at: Date.today,
                                 assessor: nil,
                                 position: "case_summary",
                                 document: assessor_assignment_document
  end

  let(:assessor_assignment_document) do
    res = {}

    AppraisalForm.struct(form_answer).each do |key, value|
      res["#{key}_desc"] = "Lorem Ipsum"
      res["#{key}_rate"] = %w[negative positive average].sample if value[:type] != :non_rag
    end

    res
  end

  let(:pdf_filename) do
    "application_case_summaries_#{form_answer.decorate.pdf_filename}"
  end

  before do
    visit admin_form_answer_case_summaries_path(form_answer, format: :pdf)
  end

  it "should generate pdf" do
    expect(page.status_code).to eq(200)
    expect(page.response_headers["Content-Disposition"]).to include "attachment; filename=\"#{pdf_filename}\""
    expect(page.response_headers["Content-Type"]).to be_eql "application/pdf"
  end
end
