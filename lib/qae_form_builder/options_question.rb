class QAEFormBuilder

  QuestionAnswerOption = Struct.new(:value, :text)

  class OptionsQuestionBuilder < QuestionBuilder

    def option value, text
      @q.options << QuestionAnswerOption.new(value, text)
    end

    def yes_no
      @q.options << QuestionAnswerOption.new(:yes, 'Yes')
      @q.options << QuestionAnswerOption.new(:no, 'No')
    end

    def financial_date_selector(ops={})
      @q.financial_date_selector = true
      @q.ops_values = ops
    end

  end

  class OptionsQuestion < Question
    attr_reader :options
    attr_accessor :financial_date_selector, :ops_values

    def after_create
      @options = []
    end
  end

end
