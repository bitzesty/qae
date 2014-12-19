class QAEFormBuilder
  class PreviousNameQuestionDecorator < QuestionDecorator
    def required_suffixes
      [:name, :refnum]
    end
  end

  class PreviousNameQuestionBuilder < QuestionBuilder
  end

  class PreviousNameQuestion < Question
  end

end
