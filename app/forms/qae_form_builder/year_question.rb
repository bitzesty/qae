class QAEFormBuilder
  class YearQuestionValidator < QuestionValidator
    def errors
      super
    end
  end

  class YearQuestionDecorator < QuestionDecorator
  end

  class YearQuestionBuilder < QuestionBuilder
  end

  class YearQuestion < Question
  end
end
