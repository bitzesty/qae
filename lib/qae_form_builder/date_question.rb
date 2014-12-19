class QAEFormBuilder

  class DateQuestionDecorator < QuestionDecorator
    def required_sub_fields
      [
        {day: "Day"}, 
        {month: "Month"},
        {year: "Year"}
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
