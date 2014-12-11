require 'spec_helper'

describe "QaePdfForms::Awards2014::Innovation::Base" do
  let!(:user) do
    FactoryGirl.create :user
  end

  let(:step1_question_answers) {
    {
      company_name: "Bitzesty",
      principal_business: 15
    }
  } 

  let(:step2_question_answers) {
    { employees: "15" }
  }

  let!(:innovation_award_form_answer) do
    FactoryGirl.create :form_answer, :innovation, 
      user: user,
      urn: "QA0001/18T",
      document: step1_question_answers.merge(step2_question_answers)
  end

  let(:award_form) { innovation_award_form_answer.award_form }
  let(:steps) { award_form.steps }

  let(:pdf_generator) do 
    innovation_award_form_answer.decorate.pdf_generator
  end

  let(:step1) { award_form.steps.first }
  let(:step2) { award_form.steps.second }

  describe "PDF generation" do 
    let(:pdf_content) do 
      rendered_pdf = pdf_generator.render
      PDF::Inspector::Text.analyze(rendered_pdf).strings
    end

    let(:award_application_title) do
      innovation_award_form_answer.decorate.award_application_title
    end

    let(:user_general_info) do
      user.decorate.general_info
    end

    let(:form_urn) do
      innovation_award_form_answer.urn
    end

    it "should include main header information" do
      expect(pdf_content).to include(award_application_title)
      expect(pdf_content).to include(user_general_info)
      expect(pdf_content).to include(form_urn)
    end

    it "should include steps headers" do
      steps.each do |step|
        expect(pdf_content).to include("Step #{step.index} of #{award_form.steps.length}: #{step.title}")
      end
    end

    it "should include answers with question titles" do
      step1_question_answers.each do |question_key, question_answer|
        question = fetch_question_by_question_key(step1.questions, question_key)

        expect(pdf_content).to include("#{question.ref} #{question.title}")
        expect(pdf_content).to include(question_answer.to_s)
      end
    end
  end

  describe "#question_title" do
    let(:question) do 
      fetch_question_by_question_key(step1.questions, :company_name)
    end

    it "shoudl return proper question title" do
      expect(pdf_generator.question_title(question)).to be_eql("#{question.ref} #{question.title}")
    end
  end

  describe "#step_header_title" do
    it "shoudl return proper header title" do
      expect(pdf_generator.step_header_title(step1)).to be_eql( "Step #{step1.index} of #{steps.length}: #{step1.title}")
    end
  end

  private

  def fetch_question_by_question_key(questions, question_key)
    questions.select { |q| q.key.to_s == question_key.to_s }.first
  end
end
