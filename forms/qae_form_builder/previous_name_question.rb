class QaeFormBuilder
  class PreviousNameQuestionValidator < QuestionValidator
  end

  class PreviousNameQuestionDecorator < QuestionDecorator
    def required_sub_fields
      [
        { name: "Name used previously" },
        { refnum: "Reference number used previously" },
      ]
    end
  end

  class PreviousNameQuestionBuilder < QuestionBuilder
  end

  class PreviousNameQuestion < Question
  end
end
