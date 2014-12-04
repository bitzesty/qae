class QAEFormBuilder

  class TextareaQuestionBuilder < QuestionBuilder

    def rows num
      @q.rows = num
    end

    def words_max num
      @q.words_max = num
    end

    def words_min num
      @q.words_min = num
    end
  end

  class TextareaQuestion < Question
    attr_accessor :rows, :words_max, :words_min
  end

end
