class QaeFormBuilder
  class TextQuestionValidator < QuestionValidator
  end

  class TextQuestionBuilder < QuestionBuilder
    def style style
      @q.style = style
    end

    def type type
      @q.type = type
    end
  end

  class TextQuestion < Question
    attr_accessor :type, :style
  end

end
