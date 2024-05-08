require "rails_helper"

shared_context "admin case summary pdf file checks" do
  let!(:user) { create :user }

  let!(:form_answer) do
    create :form_answer,
           :recommended,
           award_type,
           user: user
  end

  let!(:assessor_assignment) do
    create :assessor_assignment, form_answer: form_answer,
                                 submitted_at: Date.today,
                                 assessor: nil,
                                 position: "case_summary",
                                 document: assessor_assignment_document
  end

  let(:assessor_assignment_document) do
    res = {}

    AppraisalForm.struct(form_answer).each_with_index do |block, index|
      key = block[0]
      res["#{key}_desc"] = "#{index}_desc"
      if block[1][:type] != :non_rag
        res["#{key}_rate"] = "positive"
      end
    end

    res
  end

  let(:pdf_generator) do
    form_answer.decorate.case_summaries_pdf_generator
  end

  let(:pdf_content) do
    rendered_pdf = pdf_generator.render
    PDF::Inspector::Text.analyze(rendered_pdf).strings
  end

  let(:urn) do
    "KA Ref: #{form_answer.urn}"
  end

  let(:applicant) do
    "Applicant: #{form_answer.decorate.company_nominee_or_application_name}"
  end

  let(:award_general_information) do
    "#{SharedPdfHelpers::DrawElements::AWARD_GENERAL_INFO_PREFIX} #{form_answer.award_year.year}"
  end

  let(:award_title) do
    form_answer.award_type_full_name.titlecase
  end

  describe "PDF generation" do
    it "should include main header information" do
      expect(pdf_content).to include(urn)
      expect(pdf_content).to include(applicant)
      expect(pdf_content).to include(award_general_information)
      expect(pdf_content).to include(award_title)
    end

    it "should contain case summary data" do
      AppraisalForm.struct(form_answer).each do |key, _|
        expect(pdf_content).to include(assessor_assignment.document["#{key}_desc"])
      end
    end
  end
end
