class QAEFormBuilder
  class TextQuestionValidator < QuestionValidator
  end

  class TextQuestionBuilder < QuestionBuilder
    def style style
      @q.style = style
    end

    def type type
      @q.type = type
    end

    def pattern pattern
      @q.pattern = pattern
    end
  end

  class TextQuestion < Question
    attr_accessor :type, :style, :pattern
  end

end
