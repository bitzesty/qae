class QAEFormBuilder
  class SupportersQuestionBuilder < QuestionBuilder
    def limit(value)
      @q.limit = value
    end

    def list_type list_type
      @q.list_type = list_type
    end
  end

  class SupportersQuestion < Question
    attr_accessor :limit, :list_type
  end

  class SupportersQuestionDecorator < MultiQuestionDecorator
  end
end
