require 'rails_helper'

describe "QaePdfForms::Awards2016::Promotion::Base" do
  include_context "pdf file checks"

  let(:step1_question_answers) {
    {
      nominee_phone: generate(:phone),
      nominee_email: generate(:email)
    }
  }

  let(:award_type) { :promotion }

  let(:nominee_name_and_surname) {
    {
      user_info_last_name: "Savovich",
      user_info_first_name: "Jovan"
    }
  }

  let(:form_answer) do
    fa = FactoryGirl.build(:form_answer, :submitted, award_type, user: user)
    fa.document = fa.document.merge(step1_question_answers.merge(step2_question_answers))
    fa.document = fa.document.merge(nominee_name_and_surname)
    fa.save!

    fa
  end
end
