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

    def sub_category_question
      @q.sub_category_question = true
    end

  end

  class OptionsQuestion < Question
    attr_reader :options
    attr_accessor :financial_date_selector, :sub_category_question, :ops_values

    def after_create
      @options = []
    end
  end

end
