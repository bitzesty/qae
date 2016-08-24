class QAEFormBuilder
  class CheckboxSeriaQuestionValidator < QuestionValidator
  end

  class CheckboxSeriaQuestionBuilder < QuestionBuilder
    def check_options check_options
      @q.check_options = check_options
    end

    def application_type_question a_type
      @q.application_type_question = a_type
    end
  end

  class CheckboxSeriaQuestion < Question
    attr_accessor :check_options, :application_type_question
  end

  class CheckboxSeriaQuestionDecorator < QuestionDecorator
    def entities
      @entities ||= (answers[delegate_obj.key.to_s] || [])
    end
  end
end
