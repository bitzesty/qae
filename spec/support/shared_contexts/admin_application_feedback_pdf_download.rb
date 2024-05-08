require "rails_helper"

shared_context "admin application feedback pdf download" do
  let!(:form_answer) do
    create :form_answer, award_type,
      :submitted,
      user: user
  end

  let(:feedback_content) do
    res = {}

    FeedbackForm.fields_for_award_type(form_answer).each do |key, value|
      res["#{key}_strength"] = "#{key} strength"
      res["#{key}_weakness"] = "#{key} weakness"
    end

    res
  end

  let!(:feedback) do
    create :feedback, form_answer: form_answer,
      document: feedback_content
  end

  let(:pdf_filename) do
    "application_feedbacks_#{form_answer.decorate.pdf_filename}"
  end

  before do
    visit download_pdf_admin_form_answer_feedbacks_path(form_answer, format: :pdf)
  end

  it "should generate pdf" do
    expect(page.status_code).to eq(200)
    expect(page.response_headers["Content-Disposition"]).to include "attachment; filename=\"#{pdf_filename}\""
    expect(page.response_headers["Content-Type"]).to be_eql "application/pdf"
  end
end
