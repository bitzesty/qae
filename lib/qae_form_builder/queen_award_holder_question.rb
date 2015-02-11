require_relative 'multi_question_decorator'

class QAEFormBuilder

  QueenAwardHolderCategory = Struct.new(:value, :text)

  class QueenAwardHolderQuestionBuilder < QuestionBuilder
    def year year
      #TODO: type checking
      @q.years << year
    end

    def category value, text
      @q.categories << QueenAwardHolderCategory.new(value, text)
    end
  end

  class QueenAwardHolderQuestion < Question
    attr_reader :categories, :years

    def after_create
      @categories = []
      @years = []
    end
  end

  class QueenAwardHolderQuestionDecorator < MultiQuestionDecorator
  end
end
