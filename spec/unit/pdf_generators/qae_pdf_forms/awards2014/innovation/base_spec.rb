require 'rails_helper'

describe "QaePdfForms::Awards2016::Innovation::Base" do
  include_context "pdf file checks"

  let(:step1_question_answers) {
    {
      company_name: "Bitzesty",
      registration_number: '123'
    }
  }

  let(:award_type) { :innovation }


  let(:form_answer) do
    fa = FactoryGirl.build(:form_answer, :submitted, award_type, user: user)
    fa.document = fa.document.merge(step1_question_answers.merge(step2_question_answers))
    fa.save!

    fa
  end
end
