class QAEFormBuilder
  class CheckboxSeriaQuestionValidator < QuestionValidator
  end

  class CheckboxSeriaQuestionBuilder < QuestionBuilder
    def check_options check_options
      @q.check_options = check_options
    end
  end

  class CheckboxSeriaQuestion < Question
    attr_accessor :check_options
  end

  class CheckboxSeriaQuestionDecorator < QuestionDecorator
    def checked_items
      @checked_items ||= (answers[delegate_obj] || [])
    end

    alias :checked_items
  end
end
