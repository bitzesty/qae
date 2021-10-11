class QAEFormBuilder
  class HeadOfBusinessQuestionValidator < QuestionValidator
  end

  class HeadOfBusinessQuestionDecorator < QuestionDecorator
    def required_sub_fields
      [
        {title: "Title"},
        {first_name: "First name"},
        {last_name: "Last name"},
        {head_job_title: "Job title / role in the organisation"},
        {head_email: "Email address"}
      ]
    end
  end

  class HeadOfBusinessQuestionBuilder < QuestionBuilder
    def sub_fields fields
      @q.sub_fields = fields
    end
  end

  class HeadOfBusinessQuestion < Question
    attr_accessor :sub_fields
  end

end
