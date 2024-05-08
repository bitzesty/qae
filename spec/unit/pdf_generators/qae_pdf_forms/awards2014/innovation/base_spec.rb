require "rails_helper"

describe "QaePdfForms::Awards2016::Innovation::Base" do
  let!(:award_year) { AwardYear.current }
  include_context "pdf file checks"

  let(:step1_question_answers) {
    {
      head_of_business: "BitZesty",
    }
  }

  let(:step2_question_answers) {
    {
      company_name: "BitZesty",
    }
  }

  let(:award_type) { :innovation }


  let(:form_answer) do
    fa = FactoryBot.build(:form_answer, :submitted, award_type, user: user)
    fa.document = fa.document.merge(step1_question_answers.merge(step2_question_answers))
    fa.save!

    fa
  end
end
