class QaeFormBuilder
  class OptionsQuestionValidator < QuestionValidator
  end

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

    def default_option(option)
      @q.default_option = option
    end

    def context_for_option(option_value, context)
      @q.context_for_options[option_value] = context
    end

    def pdf_context_for_option(option_value, context)
      @q.pdf_context_for_options[option_value] = context
    end

    def ineligible_option ineligible_option
      @q.ineligible_option = ineligible_option
    end
  end

  class OptionsQuestion < Question
    attr_reader :options

    attr_accessor :financial_date_selector,
                  :sub_category_question,
                  :ops_values,
                  :default_option,
                  :context_for_options,
                  :pdf_context_for_options,
                  :ineligible_option

    def after_create
      @options = []
      @context_for_options = {}
      @pdf_context_for_options = {}
    end

    def context_for_option(option_value)
      pdf_context_for_options[option_value] || context_for_options[option_value]
    end

  end

end
