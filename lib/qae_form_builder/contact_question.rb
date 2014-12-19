class QAEFormBuilder

  class ContactQuestionDecorator < QuestionDecorator
    def required_suffixes
      [:title, :first_name, :last_name]
    end
  end

  class ContactQuestionBuilder < QuestionBuilder
  end

  class ContactQuestion < Question
  end

end
