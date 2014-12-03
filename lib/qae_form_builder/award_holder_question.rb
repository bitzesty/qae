class QAEFormBuilder

  AwardHolderCategory = Struct.new(:value, :text)

  class AwardHolderQuestionBuilder < QuestionBuilder

    def year year
      #TODO: type checking
      @q.years << year
    end

    def category value, text
      @q.categories << AwardHolderCategory.new(value, text)
    end

  end

  class AwardHolderQuestion < Question
    attr_reader :categories, :years

    def after_create
      @categories = []
      @years = []
    end

  end

end
