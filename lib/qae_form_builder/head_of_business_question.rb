class QAEFormBuilder
  class HeadOfBusinessQuestionDecorator < QuestionDecorator
    def required_sub_fields
      [
        {title: "Title"},
        {first_name: "First name"},
        {last_name: "Last name"},
        {honours: "Personal Honours"}
      ]
    end
  end

  class HeadOfBusinessQuestionBuilder < QuestionBuilder
  end

  class HeadOfBusinessQuestion < Question
  end

end
