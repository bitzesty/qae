class QaeFormBuilder
  class ByYearsQuestionValidator < QuestionValidator
    def errors
      result = super

      return result unless question.visible?

      if question.required?
        question.active_fields.each.with_index(1) do |suffix, idx|
          if question.input_value(suffix:).blank?
            result[question.hash_key(suffix:)] ||= ""
            result[question.hash_key(suffix:)] << "Question #{question.ref || question.sub_ref} is incomplete. Financial year #{idx} is required and must be filled in."
          end
        end
      end

      # Need to raise a validation error without displaying error as there will be custom warning.
      result["#{question.hash_key}/halted"] = "" if question.halted?

      if question.fields_count && question.validatable_years_position.present?
        validatable_years = (1..question.fields_count).to_a[*question.validatable_years_position]

        question.active_fields.each.with_index(1) do |suffix, idx|
          value = question.input_value(suffix:)
          threshold = idx.in?(validatable_years) ? 2 : 0

          if value.present? && value.to_i < threshold
            result[question.hash_key(suffix:)] ||= ""
            result[question.hash_key(suffix:)] << result[question.hash_key(suffix:)] << "Question #{question.ref || question.sub_ref} is invalid. Required minimum is #{threshold} employees."
          end
        end
      end

      result
    end
  end

  class ByYearsQuestionDecorator < QuestionDecorator
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
      return [] unless fields_count

      (1..fields_count).map { |y| "#{y}of#{fields_count}" }
    end

    def fields_count
      c = active_by_year_condition
      c ||= default_by_year_condition
      return nil unless c

      c.years
    end

    def active_by_year_condition
      delegate_obj.by_year_conditions.find do |c|
        if c.question_value.respond_to?(:call)
          q = form[c.question_key]
          if q.is_a?(QaeFormBuilder::DateQuestion) || q.is_a?(QaeFormBuilder::DateQuestionDecorator)
            date = []
            q.required_sub_fields.each do |sub|
              date << q.input_value(suffix: sub.keys[0])
            end

            date = begin
              Date.parse(date.join("/"))
            rescue StandardError
              nil
            end

            c.question_value.call(date)
          else
            c.question_value.call(form[c.question_key].input_value)
          end
        else
          form[c.question_key].input_value == c.question_value
        end
      end
    end

    def default_by_year_condition
      delegate_obj.by_year_conditions.find do |c|
        return false unless c.question_value.respond_to?(:call)

        (c.options || {}).dig(:default) == true
      end
    end
  end

  class ByYearsQuestionBuilder < QuestionBuilder
    def type(type)
      @q.type = type
    end

    def label(label)
      @q.label = label
    end

    def by_year_condition(k, v, num, options = {})
      @q.by_year_conditions << ByYearsCondition.new(k, v, num, **options)
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

  class ByYearsCondition
    attr_accessor :question_key, :question_value, :years, :options

    def initialize question_key, question_value, years, **options
      @question_key = question_key
      @question_value = question_value
      @years = years
      @options = options
    end
  end

  class ByYearsQuestion < Question
    attr_accessor :type,
                  :by_year_conditions,
                  :label,
                  :employees_question,
                  :first_year_min_value,
                  :first_year_validation_message,
                  :validatable_years_position

    def after_create
      @by_year_conditions = []
    end
  end
end
