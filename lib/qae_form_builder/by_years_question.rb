class QAEFormBuilder

  class ByYearsQuestionDecorator < QuestionDecorator
    def fieldset_classes
      result = super
      result << "question-#{type}-by-years"
      result
    end

    def format_label y
      if delegate_obj.label && delegate_obj.label.is_a?(Proc)
        delegate_obj.label.call y
      else
        delegate_obj.label
      end
    end
  end

  class ByYearsQuestionBuilder < QuestionBuilder
    def type type
      @q.type = type
    end

    def label label
      @q.label = label
    end

    def by_year_condition k, v, num, options = {}
      @q.by_year_conditions << ByYearsCondition.new(k, v, num, options)
    end
  end

  class ByYearsCondition
    attr_accessor :question_key, :question_value, :years, :span_class
    def initialize question_key, question_value, years, options = {}
      @question_key = question_key
      @question_value = question_value
      @years = years
      @options = options
      @span_class = options[:span_class]
    end
  end

  class ByYearsQuestion < Question
    attr_accessor :type, :by_year_conditions, :label
    def after_create
      @by_year_conditions = []
    end 
  end

end
