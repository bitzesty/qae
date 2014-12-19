class QAEFormBuilder
  class HeadOfBusinessQuestionDecorator < QuestionDecorator
    def required_suffixes
      [:title, :first_name, :last_name, :honours]
    end
  end

  class HeadOfBusinessQuestionBuilder < QuestionBuilder
  end

  class HeadOfBusinessQuestion < Question
  end

end
