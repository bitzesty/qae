class QAEFormBuilder
  class HeadOfBusinessQuestionValidator < QuestionValidator
  end

  class HeadOfBusinessQuestionDecorator < QuestionDecorator
    def required_sub_fields
      [
        {first_name: "First name"},
        {last_name: "Last name"}
      ]
    end
  end

  class HeadOfBusinessQuestionBuilder < QuestionBuilder
  end

  class HeadOfBusinessQuestion < Question
  end

end
