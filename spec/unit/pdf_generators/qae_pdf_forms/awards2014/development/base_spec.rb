require "rails_helper"

describe "QaePdfForms::Awards2016::Development::Base" do
  let!(:award_year) { AwardYear.current }

  include_context "pdf file checks"

  let(:step1_question_answers) do
    {
      head_of_business: "BitZesty",
    }
  end

  let(:step2_question_answers) do
    {
      company_name: "BitZesty",
    }
  end

  let(:award_type) { :development }

  let(:form_answer) do
    fa = FactoryBot.build(:form_answer, :submitted, award_type, user:)
    fa.document = fa.document.merge(step1_question_answers.merge(step2_question_answers))
    fa.save!

    fa
  end
end
