class QaeFormBuilder
  class TurnoverExportsCalculationQuestionValidator < QuestionValidator
  end

  class TurnoverExportsCalculationQuestionDecorator < QuestionDecorator
    def format_label(y)
      if delegate_obj.label && delegate_obj.label.is_a?(Proc)
        delegate_obj.label.call y
      else
        delegate_obj.label
      end
    end

    def active_fields
      (1..fields_count).map { |y| "#{y}of#{fields_count}" }
    end

    def fields_count
      if delegate_obj.one_option_financial_data_mode.present?
        3
      else
        c = active_by_year_condition
        return nil unless c

        c.years
      end
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
  end

  class TurnoverExportsCalculationQuestionBuilder < QuestionBuilder
    def label(label)
      @q.label = label
    end

    def by_year_condition(k, v, num, options = {})
      @q.by_year_conditions << ByYearsCondition.new(k, v, num, **options)
    end

    def turnover(key)
      @q.turnover_question = key.to_s.to_sym
    end

    def exports(key)
      @q.exports_question = key.to_s.to_sym
    end

    def one_option_financial_data_mode(val)
      @q.one_option_financial_data_mode = val
    end
  end

  class TurnoverExportsCalculationCondition
    attr_accessor :question_key,
                  :question_value,
                  :years,
                  :span_class

    def initialize question_key, question_value, years, **options
      @question_key = question_key
      @question_value = question_value
      @years = years
      @options = options
    end
  end

  class TurnoverExportsCalculationQuestion < Question
    attr_accessor :by_year_conditions,
                  :label,
                  :turnover_question,
                  :exports_question,
                  :one_option_financial_data_mode

    def after_create
      @by_year_conditions = []
    end
  end
end
