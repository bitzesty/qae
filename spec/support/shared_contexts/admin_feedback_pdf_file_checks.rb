require "rails_helper"

shared_context "admin feedback pdf file checks" do
  let!(:user) { create :user }

  let!(:form_answer) do
    create :form_answer,
           award_type,
           :submitted,
           user: user
  end

  let(:feedback_content) do
    res = {}

    FeedbackForm.fields_for_award_type(form_answer).each_with_index do |block, index|
      key = block[0]

      if block[1][:type] == :strengths
        res["#{key}_rate"] = %w(average neutral negative positive).sample
      else
        res["#{key}_strength"] = "#{index}_strength"
        res["#{key}_weakness"] = "#{index}_weakness"
      end
    end

    res
  end

  let!(:feedback) do
    create :feedback, form_answer: form_answer,
                      document: feedback_content
  end

  let(:pdf_generator) do
    form_answer.decorate.feedbacks_pdf_generator
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

    it "should contain feedback data" do
      FeedbackForm.fields_for_award_type(form_answer).each do |key, opts|
        if opts[:type] == :strengths
          year = form_answer.award_year.year
          expect(pdf_content).to include(AppraisalForm.const_get("STRENGTH_OPTIONS_#{year}").detect { |k, v| v == feedback.document["#{key}_rate"] }[0] )
        else
          expect(pdf_content).to include(feedback.document["#{key}_strength"])
          expect(pdf_content).to include(feedback.document["#{key}_weakness"])
        end
      end
    end
  end
end
