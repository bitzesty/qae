class QaeFormBuilder
  class ContactEmailQuestionValidator < QuestionValidator
  end

  class ContactEmailQuestionDecorator < QuestionDecorator
    def required_sub_fields
      [
        { primary: "Primary" },
        { confirmation: "Confirmation" }
      ]
    end
  end

  class ContactEmailQuestionBuilder < QuestionBuilder
  end

  class ContactEmailQuestion < Question
  end
end
