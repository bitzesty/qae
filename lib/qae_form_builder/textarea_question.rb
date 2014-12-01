class QAEFormBuilder

  class TextareaQuestionBuilder < QuestionBuilder

    def rows num
      @q.rows = num
    end

    def chars_max num
      @q.chars_max = num
    end

    def words_max num
      @q.words_max = num
    end

  end

  class TextareaQuestion < Question
    attr_accessor :rows, :chars_max, :words_max
  end

end
