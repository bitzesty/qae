class QaeFormBuilder
  class ByYearsLabelQuestionValidator < QuestionValidator
    REQUIRED_SUB_FIELDS = %i[day month year].freeze

    def errors
      result = super

      return result unless question.visible?

      dates = question.active_fields.each_with_object(Hash[]) do |field, outer|
        suffix = "#{question.key}_#{field}"
        parts = REQUIRED_SUB_FIELDS.each_with_object([]) do |sub, inner|
          key = "#{suffix}#{sub}"
          inner << answers[key]
        end

        if parts.any?(&:blank?)
          outer[suffix] = :blank
        else
          date = parts.join("/")
          outer[suffix] = ::Utils::Date.valid?(date) ? Date.parse(date) : :invalid
        end
      end

      required = question.required?

      dates.each.with_index(1) do |(key, value), idx|
        next unless value == :invalid || value == :blank
        result[key] ||= ""
        result[key] << "Question #{question.ref || question.sub_ref} is incomplete. It is required and must be filled in. Use the format DD/MM/YYYY." if value == :blank && required
        result[key] << "The date entered for Question #{question.ref || question.sub_ref} is not valid. Use the format DD/MM/YYYY." if value == :invalid
      end

      dates.each_cons(2) do |values|
        beginning_key, beginning_date = values[0]
        end_key, end_date = values[-1]

        next if [beginning_date, end_date].any? { |v| v.nil? || v.in?(%i[invalid blank]) }

        if beginning_date > end_date
          result[beginning_key] ||= ""
          result[end_key] ||= ""
          result[beginning_key] << "The date entered for Question #{question.ref || question.sub_ref} should be before #{end_date.strftime("%d/%m/%Y")}."
          result[end_key] << "The date entered for Question #{question.ref || question.sub_ref} should be after #{beginning_date.strftime("%d/%m/%Y")}."
        end
      end

      validatable = dates.values.each_cons(2).reject { |values| values.any? { |v| v.nil? || v.in?(%i[invalid blank]) } }

      return result if validatable.blank?

      msg = "There is an error because financial year cannot be longer than 18 months, please double check your year end dates"

      validatable.each do |d1, d2|
        check = d2.months_ago(18) <= d1

        unless check
          result[question.key] = msg
          break
        end
      end

      result
    end
  end

  class ByYearsLabelQuestionDecorator < QuestionDecorator
    def fieldset_classes
      result = super
      result << "question-#{type}-by-years"
      result
    end

    def format_label y
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
            rescue
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

  class ByYearsLabelQuestionBuilder < QuestionBuilder
    def type type
      @q.type = type
    end

    def label label
      @q.label = label
    end

    def by_year_condition k, v, num, options = {}
      @q.by_year_conditions << ByYearsCondition.new(k, v, num, **options)
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

  class ByYearsLabelQuestion < Question
    attr_accessor :type, :by_year_conditions, :label
    def after_create
      @by_year_conditions = []
    end
  end
end
