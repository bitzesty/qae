class QAEFormBuilder
  class CheckboxSeriaQuestionValidator < QuestionValidator
    def errors
      result = super

      if question.input_value && question.selection_limit
        if question.input_value.size > question.selection_limit
          result[question.hash_key] ||= ""
          result[question.hash_key] << "Select a maximum of #{question.selection_limit}"
        end
      end

      result
    end
  end

  class CheckboxSeriaQuestionDecorator < QuestionDecorator
    def fieldset_data_hash
      result = super
      result['selection-limit'] = delegate_obj.selection_limit if delegate_obj.selection_limit

      result
    end
  end

  class CheckboxSeriaQuestionBuilder < QuestionBuilder
    def check_options check_options
      @q.check_options = check_options
    end

    def application_type_question a_type
      @q.application_type_question = a_type
    end

    def selection_limit limit
      @q.selection_limit = limit
    end
  end

  class CheckboxSeriaQuestion < Question
    attr_accessor :check_options, :application_type_question, :selection_limit
  end

  class CheckboxSeriaQuestionDecorator < QuestionDecorator
    def entities
      @entities ||= (answers[delegate_obj.key.to_s] || [])
    end
  end
end
