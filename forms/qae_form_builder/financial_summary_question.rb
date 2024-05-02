class QaeFormBuilder
  class FinancialSummaryQuestionValidator < QuestionValidator
    def errors
      {}
    end
  end

  class FinancialSummaryQuestionBuilder < QuestionBuilder
    def partial(name)
      @q.partial = name
    end
  end

  class FinancialSummaryQuestion < Question
    attr_accessor :partial
  end
end
