class QAEFormBuilder

  class ContactEmailQuestionDecorator < QuestionDecorator
    def required_suffixes
      [:primary, :confirmation]
    end
  end

  class ContactEmailQuestionBuilder < QuestionBuilder
  end

  class ContactEmailQuestion < Question
  end

end
