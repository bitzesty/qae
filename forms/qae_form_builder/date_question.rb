class QaeFormBuilder
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
          result[question.hash_key] << "Question #{question.ref || question.sub_ref} is incomplete. It requires a date in the format DD/MM/YYYY."
        end
      else
        if date_min && date < date_min
          result[question.hash_key] ||= ""
          result[question.hash_key] << "Question #{question.ref || question.sub_ref} is incomplete. Date should be after #{date_min.strftime('%d/%m/%Y')}."
        end

        if date_max && date > date_max
          result[question.hash_key] ||= ""
          result[question.hash_key] << "Question #{question.ref || question.sub_ref} is incomplete. Date should be before #{date_max.strftime('%d/%m/%Y')}."
        end
      end

      result = process_dynamic_dates(date, result)

      result
    end

    def process_dynamic_dates(date, result)
      return result if !question.delegate_obj.dynamic_date_max || !date

      settings = question.delegate_obj.dynamic_date_max

      if (key = answers[settings[:conditional].to_s]).present?
        date_max = Date.parse(settings[:dates][key]) rescue nil

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
      result << 'question-dynamic-date-max' if delegate_obj.dynamic_date_max
      result << 'question-date-min' if delegate_obj.date_min
      result << 'question-date-between' if delegate_obj.date_between
      result
    end

    def fieldset_data_hash
      result = super
      result['date-max'] = delegate_obj.date_max if delegate_obj.date_max
      result['date-min'] = delegate_obj.date_min if delegate_obj.date_min
      result['date-between'] = delegate_obj.date_between.join(',') if delegate_obj.date_between

      if delegate_obj.dynamic_date_max
        result['dynamic-date-max'] = delegate_obj.dynamic_date_max.to_json
      end

      result
    end
  end

  class DateQuestionBuilder < QuestionBuilder
    def date
      @q.date = true
    end

    def date_max(date)
      @q.date_max = date
    end

    def dynamic_date_max(hash)
      @q.dynamic_date_max = hash
    end

    def date_min(date)
      @q.date_min = date
    end

    def date_between(date1, date2)
      @q.date_between = [date1, date2]
    end
  end

  class DateQuestion < Question
    attr_accessor :date_max, :date_min, :date_between, :date, :dynamic_date_max

    def initialize step, key, title, opts={}
      super

      @date = false
      @date_min = false
      @date_max = false
      @dynamic_date_max = false
      @date_between = false
    end
  end
end
