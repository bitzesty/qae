class QaeFormBuilder
  class PositionDetailsQuestionValidator < QuestionValidator
  end

  class PositionDetailsQuestionBuilder < QuestionBuilder
    def details_words_max(value)
      @q.details_words_max = value
    end
  end

  class PositionDetailsQuestion < Question
    attr_accessor :details_words_max
  end

  class PositionDetailsQuestionDecorator < MultiQuestionDecorator
  end
end
