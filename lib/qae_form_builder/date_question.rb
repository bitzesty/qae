class QAEFormBuilder

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
