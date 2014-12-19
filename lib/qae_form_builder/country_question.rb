class QAEFormBuilder

  class CountryQuestionDecorator < QuestionDecorator
    def required_sub_fields
      [{country: "Country"}]
    end
  end

  class CountryQuestionBuilder < QuestionBuilder
  end

  class CountryQuestion < Question
  end

end
