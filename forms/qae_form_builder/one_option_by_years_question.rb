class QaeFormBuilder
  class OneOptionByYearsQuestionValidator < ::QaeFormBuilder::ByYearsQuestionValidator
  end

  class OneOptionByYearsQuestionDecorator < QuestionDecorator
    def fieldset_classes
      result = super
      result << "question-#{type}-by-years"
      result
    end

    def format_label(y)
      if delegate_obj.label && delegate_obj.label.is_a?(Proc)
        delegate_obj.label.call y
      else
        delegate_obj.label
      end
    end

    def has_drops?
      last = nil
      active_fields.each do |f|
        v = input_value(suffix: f).to_f
        return true if (last && v < last) || v < 0

        last = v
      end
      false
    end

    def active_fields
      (1..3).map { |y| "#{y}of3" }
    end

    def fields_count
      3
    end

    def active_by_year_condition
      delegate_obj.by_year_conditions.find do |c|
        form[c.question_key].input_value == c.question_value
      end
    end
  end

  class OneOptionByYearsQuestionBuilder < QuestionBuilder
    def type(type)
      @q.type = type
    end

    def label(label)
      @q.label = label
    end

    def employees_question
      @q.employees_question = true
    end

    def first_year_min_value(min_value, validation_message)
      @q.first_year_min_value = min_value
      @q.first_year_validation_message = validation_message
    end

    def validatable_years_position(values)
      @q.validatable_years_position = values
    end
  end

  class OneOptionByYearsCondition
    attr_accessor :question_key, :question_value, :years

    def initialize question_key, question_value, years, **options
      @question_key = question_key
      @question_value = question_value
      @years = years
      @options = options
    end
  end

  class OneOptionByYearsQuestion < Question
    attr_accessor :type,
                  :label,
                  :employees_question,
                  :first_year_min_value,
                  :first_year_validation_message,
                  :validatable_years_position
  end
end
