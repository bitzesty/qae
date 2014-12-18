class QAEFormBuilder

  class CountryQuestionDecorator < QuestionDecorator
    def required_suffixes
      [:country]
    end
  end

  class CountryQuestionBuilder < QuestionBuilder
  end

  class CountryQuestion < Question
  end

end
