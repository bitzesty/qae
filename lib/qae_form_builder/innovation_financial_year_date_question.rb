class QAEFormBuilder
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
