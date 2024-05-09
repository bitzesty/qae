class QaeFormBuilder
  class InnovationFinancialYearDateQuestionValidator < QuestionValidator
    def errors
      result = super

      date = []
      question.required_sub_fields.each do |sub_field|
        date << question.input_value(suffix: sub_field.keys[0])
      end

      date << Date.current.year.to_s
      day = question.input_value(suffix: "day")
      month = question.input_value(suffix: "month")

      if day.blank? || month.blank?
        date = nil
      else
        date = Date.parse(date.join("/")) rescue nil
      end

      if question.required? && !date
        result[question.hash_key] ||= ""
        result[question.hash_key] << "#{question.ref || question.sub_ref} is invalid. Financial year-end is required. Use the format DD/MM"
      end

      result
    end
  end

  class InnovationFinancialYearDateQuestionDecorator < QuestionDecorator
    def required_sub_fields
      [
        { day: "Day" },
        { month: "Month" },
      ]
    end
  end

  class InnovationFinancialYearDateQuestionBuilder < QuestionBuilder
    def financial_date_pointer
      @q.financial_date_pointer = true
    end
  end

  class InnovationFinancialYearDateQuestion < Question
    attr_accessor :financial_date_pointer
  end
end
