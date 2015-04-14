class QAEFormBuilder
  class OptionsWithPreselectedConditionsQuestionValidator < OptionsQuestionValidator
  end

  class PlaceholderPreselectedCondition
    attr_accessor :question_key,
                  :question_suffix,
                  :parent_question_answer_key,
                  :answer_key,
                  :question_value,
                  :placeholder_text

    def initialize(question_key, options={})
      @question_key = question_key
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end

  class OptionsWithPreselectedConditionsQuestion < OptionsQuestion
    attr_accessor :main_header,
                  :placeholder_preselected_conditions,
                  :options,
                  :question_key

    def after_create
      @placeholder_preselected_conditions = []
      @options = []
    end
  end

  class OptionsWithPreselectedConditionsQuestionBuilder < OptionsQuestionBuilder
    def main_header text
      @q.main_header = text
    end

    def placeholder_preselected_condition(q_key, options={})
      @q.question_key = q_key
      @q.placeholder_preselected_conditions << PlaceholderPreselectedCondition.new(q_key, options)
    end
  end

  class OptionsWithPreselectedConditionsQuestionDecorator < QuestionDecorator
    def linked_answers
      @linked_answers ||= JSON.parse(answers[delegate_obj.question_key.to_s] || '[]').map do |answer|
        JSON.parse(answer)
      end
    end

    def preselected_condition
      @preselected_condition ||= placeholder_preselected_conditions.detect do |c|
        linked_answers.select do |a|
          a[c.question_suffix.to_s] == c.parent_question_answer_key
        end.present?
      end
    end

    def placeholder_preselected_conditions
      @placeholder_preselected_conditions ||= delegate_obj.placeholder_preselected_conditions
    end

    def preselected_condition_by_option(option)
      placeholder_preselected_conditions.detect do |condition|
        condition.question_value == option.value
      end
    end

    def depends_on
      delegate_obj.question_key.to_s
    end
  end
end
