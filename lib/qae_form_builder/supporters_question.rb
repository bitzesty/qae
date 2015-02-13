class QAEFormBuilder
  class SupportersQuestionBuilder < QuestionBuilder
    def limit(value)
      @q.limit = value
    end
  end

  class SupportersQuestion < Question
    attr_accessor :limit
  end

  class SupportersQuestionDecorator < MultiQuestionDecorator
  end
end
