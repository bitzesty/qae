require 'rails_helper'

describe "QaePdfForms::Awards2014::Promotion::Base" do
  include_context "pdf file checks"

  let(:step1_question_answers) {
    {
      nominee_first_name: "Genry",
      nominee_last_name: "Greenfield"
    }
  } 

  let(:award_type) { :promotion }

  let(:form_answer) do
    FactoryGirl.create :form_answer, :submitted, award_type, 
      user: user,
      document: step1_question_answers.merge(step2_question_answers)
  end
end
