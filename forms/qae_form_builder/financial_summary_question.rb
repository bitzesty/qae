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

    def one_option
      @q.one_option = true
    end
  end

  class FinancialSummaryQuestion < Question
    attr_accessor :partial, :one_option

    def one_option?
      !!one_option
    end
  end
end
