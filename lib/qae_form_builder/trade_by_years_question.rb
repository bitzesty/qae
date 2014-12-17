class QAEFormBuilder

  class TradeByYearsPercentageQuestionDecorator < QuestionDecorator
    def fieldset_classes
      result = super
      result << 'question-number-by-years'
      result
    end
  end

  class TradeByYearsQuestionDecorator < QuestionDecorator
    def fieldset_classes
      result = super
      result << 'question-money-by-years'
      result
    end
  end

  class TradeFinancialYearDatesQuestionDecorator < QuestionDecorator
    def fieldset_classes
      result = super
      result << 'question-date-by-years'
      result
    end
  end

  class TradeFinancialYearDatesQuestionBuilder < QuestionBuilder
  end

  class TradeFinancialYearDatesQuestion < Question
    def decorate options = {}
      TradeFinancialYearDatesQuestionDecorator.new self, options
    end
  end

  class TradeByYearsQuestionBuilder < QuestionBuilder
  end

  class TradeByYearsQuestion < Question
    def decorate options = {}
      TradeByYearsQuestionDecorator.new self, options
    end
  end

  class TradeByYearsPercentageQuestionBuilder < QuestionBuilder
  end

  class TradeByYearsPercentageQuestion < Question
    def decorate options = {}
      TradeByYearsPercentageQuestionDecorator.new self, options
    end
  end
end
