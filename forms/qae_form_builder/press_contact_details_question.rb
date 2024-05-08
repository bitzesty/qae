# frozen_string_literal: true

class QaeFormBuilder
  class PressContactDetailsQuestionValidator < QuestionValidator
  end

  class PressContactDetailsQuestionDecorator < QuestionDecorator
    def required_sub_fields
      [
        { title: "Title" },
        { first_name: "First name" },
        { last_name: "Last name" },
        { telephone: "Telephone" },
        { email: "Email address" },
      ]
    end
  end

  class PressContactDetailsQuestionBuilder < QuestionBuilder
    def sub_fields fields
      @q.sub_fields = fields
    end
  end

  class PressContactDetailsQuestion < Question
    attr_accessor :sub_fields
  end

end
