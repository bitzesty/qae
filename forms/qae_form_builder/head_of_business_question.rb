class QaeFormBuilder
  class HeadOfBusinessQuestionValidator < QuestionValidator
  end

  class HeadOfBusinessQuestionDecorator < QuestionDecorator
    def required_sub_fields
      [
        { title: "Title" },
        { first_name: "First name" },
        { last_name: "Last name" },
        { honours: "Personal Honours (optional)" },
        { job_title: "Job title or role in the organisation" },
        { email: "Email address" },
      ]
    end
  end

  class HeadOfBusinessQuestionBuilder < QuestionBuilder
    def sub_fields(fields)
      @q.sub_fields = fields
    end
  end

  class HeadOfBusinessQuestion < Question
    attr_accessor :sub_fields
  end
end
