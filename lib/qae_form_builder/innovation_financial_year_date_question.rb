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
  end

  class InnovationFinancialYearDateQuestion < Question
  end

end
