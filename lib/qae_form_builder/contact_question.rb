class QAEFormBuilder

  class ContactQuestionDecorator < QuestionDecorator
    def required_sub_fields
      [
        {title: "Title"},
        {first_name: "First name"},
        {last_name: "Last name"}
      ]
    end
  end

  class ContactQuestionBuilder < QuestionBuilder
  end

  class ContactQuestion < Question
  end

end
