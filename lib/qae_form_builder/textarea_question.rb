class QAEFormBuilder
  class TextareaQuestionValidator < QuestionValidator
    def errors
      result = super

      limit = question.delegate_obj.words_max

      limit_with_buffer = limit
      limit_with_buffer = (limit + limit * 0.1).to_i + 1 if limit > 15
      length = question.input_value && question.input_value.split(" ").length

      if limit_with_buffer && length && length > limit_with_buffer
        result[question.hash_key] ||= ""
        result[question.hash_key] << " Exeeded #{limit} words limit."
      end

      result
    end
  end

  class TextareaQuestionBuilder < QuestionBuilder
    def rows(num)
      @q.rows = num
    end

    def words_max(num)
      @q.words_max = num
    end
  end

  class TextareaQuestion < Question
    attr_accessor :rows, :words_max
  end
end
