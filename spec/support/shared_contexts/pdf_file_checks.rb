require 'rails_helper'

shared_context "pdf file checks" do
  let!(:user) do
    FactoryGirl.create :user
  end

  let(:step2_question_answers) {
    { invoicing_unit_relations: 'Invoicing unit relations' }
  }

  let(:award_form) { form_answer.award_form }
  let(:steps) { award_form.decorate.steps }

  let(:pdf_generator) do
    form_answer.decorate.pdf_generator
  end

  let(:step1) { award_form.steps.first }
  let(:step2) { award_form.steps.second }

  let(:pdf_content) do
    rendered_pdf = pdf_generator.render
    PDF::Inspector::Text.analyze(rendered_pdf).strings
  end

  let(:award_application_title) do
    form_answer.decorate.award_application_title.upcase
  end

  let(:user_general_info) do
    user.decorate.general_info_print
  end

  let(:form_urn) do
    form_answer.urn
  end

  before do
    allow_any_instance_of(FormAnswer).to receive(:eligible?) { true }
    form_answer
  end

  describe "PDF generation" do
    it "should include main header information" do
      expect(pdf_content).to include(award_application_title)
      expect(pdf_content).to include(user_general_info)
      expect(pdf_content).to include(form_urn)
    end

    it "should include steps headers" do
      steps.each do |step|
        title = "#{step.title.upcase}:"

        if award_type == :trade
          # For Trade form PDF::Inspector::Text
          # returns  "Step 2 of 6: Description of Goods or Services, Markets and", "Marketing"
          # instead of  "Step 2 of 6: Description of Goods or Services, Markets and Marketing"
          # as "Marketing" in pdf is located in new line
          title = title.gsub(' Marketing', '')
        end

        expect(pdf_content).to include(title)
      end
    end

    it "should include answers with question titles" do
      step1_question_answers.each do |question_key, question_answer|
        question = fetch_question_by_question_key(step1.questions, question_key)

        expect(pdf_content).to include(question.decorate.escaped_title)
        expect(pdf_content).to include(question_answer)
      end
    end
  end

  private

  def fetch_question_by_question_key(questions, question_key)
    questions.select { |q| q.key.to_s == question_key.to_s }.first
  end

  def question_option_title(question, answer)
    question.options.select do |option|
      option.value.to_s == answer.to_s
    end.first.text
  end
end
