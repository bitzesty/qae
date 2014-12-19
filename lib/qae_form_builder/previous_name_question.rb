class QAEFormBuilder
  class PreviousNameQuestionDecorator < QuestionDecorator
    def required_sub_fields
      [
        {name: "Name"}, 
        {refnum: "Refnum"}
      ]
    end
  end

  class PreviousNameQuestionBuilder < QuestionBuilder
  end

  class PreviousNameQuestion < Question
  end

end
