class QAEFormBuilder

  class DevelopmentFinancialYearDatesQuestionDecorator < QuestionDecorator
    def fieldset_classes
      result = super
      result << 'question-date-by-years'
      result
    end
  end

  class DevelopmentByYearsQuestionDecorator < QuestionDecorator
    def fieldset_classes
      result = super
      result << 'question-money-by-years'
      result
    end
  end

  class DevelopmentFinancialYearDatesQuestionBuilder < QuestionBuilder
  end

  class DevelopmentFinancialYearDatesQuestion < Question
    def decorate options = {}
      DevelopmentFinancialYearDatesQuestionDecorator.new self, options
    end
  end

  class DevelopmentByYearsQuestionBuilder < QuestionBuilder
  end

  class DevelopmentByYearsQuestion < Question
    def decorate options = {}
      DevelopmentByYearsQuestionDecorator.new self, options
    end
  end

  class DevelopmentByYearsNumberQuestionBuilder < QuestionBuilder
  end

  class DevelopmentByYearsNumberQuestion < Question
  end
end
