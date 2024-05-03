class QaeFormBuilder
  class QueenAwardApplicationsQuestionValidator < MultiQuestionValidator
  end

  QueenAwardApplicationsCategory = Struct.new(:value, :text)
  QueenAwardApplicationsOutcome = Struct.new(:value, :text)

  class QueenAwardApplicationsQuestionBuilder < QuestionBuilder
    def year(year)
      # TODO: type checking
      @q.years << year
    end

    def category(value, text)
      @q.categories << QueenAwardApplicationsCategory.new(value, text)
    end

    def outcome(value, text)
      @q.outcomes << QueenAwardApplicationsOutcome.new(value, text)
    end

    def children_options_depends_on(str)
      @q.children_options_depends_on = str
    end

    def dependable_values(values)
      @q.dependable_values = values.join(",")
    end
  end

  class QueenAwardApplicationsQuestion < Question
    attr_reader :categories, :years, :outcomes
    attr_accessor :children_options_depends_on, :dependable_values

    def after_create
      @categories = []
      @years = []
      @outcomes = []
    end
  end

  class QueenAwardApplicationsQuestionDecorator < MultiQuestionDecorator
    def required_sub_fields_list
      %w[category year outcome]
    end
  end
end
