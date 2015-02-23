require 'rails_helper'

describe "QaePdfForms::Awards2014::Promotion::Base" do
  let!(:user) do
    FactoryGirl.create :user
  end

  let(:step1_question_answers) {
    {
      company_name: "Bitzesty",
      registration_number: '123'
    }
  } 

  let(:step2_question_answers) {
    { invoicing_unit_relations: 'Invoicing unit relations' }
  }

  let(:promotion_award_form_answer) do
    FactoryGirl.create :form_answer, :submitted, :promotion, 
      user: user,
      document: step1_question_answers.merge(step2_question_answers)
  end

  let(:award_form) { promotion_award_form_answer.award_form }
  let(:steps) { award_form.decorate.steps }

  let(:pdf_generator) do 
    promotion_award_form_answer.decorate.pdf_generator
  end

  let(:step1) { award_form.steps.first }
  let(:step2) { award_form.steps.second }

  before do
    FormAnswer.any_instance.stub(:eligible?) { true }
    promotion_award_form_answer
  end

  describe "PDF generation" do 
    let(:pdf_content) do 
      rendered_pdf = pdf_generator.render
      PDF::Inspector::Text.analyze(rendered_pdf).strings
    end

    let(:award_application_title) do
      promotion_award_form_answer.decorate.award_application_title
    end

    let(:user_general_info) do
      user.decorate.general_info
    end

    let(:form_urn) do
      promotion_award_form_answer.urn
    end

    it "should include main header information" do
      expect(pdf_content).to include(award_application_title)
      expect(pdf_content).to include(user_general_info)
      expect(pdf_content).to include(form_urn)
    end

    it "should include steps headers" do
      steps.each do |step|
        expect(pdf_content).to include(step.complex_title)
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
