class QAEFormBuilder
  class InnovationFinancialYearDateQuestionBuilder < QuestionBuilder
  end

  class InnovationFinancialYearDateQuestion < Question
  end

  class InnovationFinancialYearDatesQuestionDecorator < QuestionDecorator
    def fieldset_classes
      result = super
      result << 'question-date-by-years'
      result
    end
  end

  class InnovationFinancialYearDatesQuestionBuilder < QuestionBuilder
  end

  class InnovationFinancialYearDatesQuestion < Question
  end

end
