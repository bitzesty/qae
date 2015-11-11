class QAEFormBuilder
  class InnovationFinancialYearDateQuestionValidator < QuestionValidator
    def errors
      result = super

      date = []
      question.required_sub_fields.each do |sub_field|
        date << question.input_value(suffix: sub_field.keys[0])
      end

      date << Date.today.year.to_s

      date = Date.parse(date.join("/")) rescue nil

      if !date && question.required?
        result[question.hash_key] ||= ""
        result[question.hash_key] << " Invalid date."
      end

      result
    end
  end

  class InnovationFinancialYearDateQuestionDecorator < QuestionDecorator
    def required_sub_fields
      [
        {day: "Day"},
        {month: "Month"},
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
