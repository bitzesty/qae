class QaeFormBuilder
  class QueenAwardHolderQuestionValidator < MultiQuestionValidator
  end

  QueenAwardHolderCategory = Struct.new(:value, :text)

  class QueenAwardHolderQuestionBuilder < QuestionBuilder
    def year(year)
      # TODO: type checking
      @q.years << year
    end

    def category(value, text)
      @q.categories << QueenAwardHolderCategory.new(value, text)
    end

    def children_options_depends_on(str)
      @q.children_options_depends_on = str
    end

    def dependable_values(values)
      @q.dependable_values = values.join(",")
    end
  end

  class QueenAwardHolderQuestion < Question
    attr_reader :categories, :years
    attr_accessor :children_options_depends_on, :dependable_values

    def after_create
      @categories = []
      @years = []
    end
  end

  class QueenAwardHolderQuestionDecorator < MultiQuestionDecorator
    def required_sub_fields_list
      %w[category year]
    end
  end
end
