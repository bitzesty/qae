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

  class InnovationByYearsQuestionDecorator < QuestionDecorator
    def fieldset_classes
      result = super
      result << 'question-money-by-years'
      result
    end
  end

  class InnovationFinancialYearDatesQuestionBuilder < QuestionBuilder
  end

  class InnovationFinancialYearDatesQuestion < Question
    def decorate options = {}
      InnovationFinancialYearDatesQuestionDecorator.new self, options
    end
  end

  class InnovationByYearsQuestionBuilder < QuestionBuilder
  end

  class InnovationByYearsQuestion < Question
    def decorate options = {}
      InnovationByYearsQuestionDecorator.new self, options
    end
  end

  class InnovationByYearsNumberQuestionBuilder < QuestionBuilder
  end

  class InnovationByYearsNumberQuestion < Question
  end
end
