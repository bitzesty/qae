class QAEFormBuilder
  class DateQuestionValidator < QuestionValidator
    def errors
      result = super

      date_max = Date.parse(question.delegate_obj.date_max) rescue nil
      date_min = Date.parse(question.delegate_obj.date_min) rescue nil

      date = []
      question.required_sub_fields.each do |sub_field|
        date << question.input_value(suffix: sub_field.keys[0])
      end

      date = Date.parse(date.join("/")) rescue nil

      if !date
        if question.required?
          result[question.hash_key] ||= ""
          result[question.hash_key] << " Invalid date."
        end
      else
        if date_min && date < date_min
          result[question.hash_key] ||= ""
          result[question.hash_key] << " Date should be greater than #{date_min.strftime('%d/%m/%Y')}."
        end

        if date_max && date > date_max
          result[question.hash_key] ||= ""
          result[question.hash_key] << " Date should be less than #{date_max.strftime('%d/%m/%Y')}."
        end
      end

      result
    end
  end

  class DateQuestionDecorator < QuestionDecorator
    def required_sub_fields
      [
        { day: "Day" },
        { month: "Month" },
        { year: "Year" }
      ]
    end
  end

  class DateQuestionDecorator < QuestionDecorator
    def fieldset_classes
      result = super
      result << 'question-date-max' if delegate_obj.date_max
      result << 'question-date-min' if delegate_obj.date_min
      result << 'question-date-between' if delegate_obj.date_between
      result
    end

    def fieldset_data_hash
      result = super
      result['date-max'] = delegate_obj.date_max if delegate_obj.date_max
      result['date-min'] = delegate_obj.date_min if delegate_obj.date_min
      result['date-between'] = delegate_obj.date_between.join(',') if delegate_obj.date_between
      result
    end

  end

  class DateQuestionBuilder < QuestionBuilder
    def date
      @q.date = true
    end

    def date_max date
      @q.date_max = date
    end

    def date_min (date)
      @q.date_min = date
    end

    def date_between (date1, date2)
      @q.date_between = [date1, date2]
    end
  end

  class DateQuestion < Question
    attr_accessor :date_max, :date_min, :date_between, :date

    def initialize step, key, title, opts={}
      super

      @date = false
      @date_min = false
      @date_max = false
      @date_between = false
    end

  end

end
