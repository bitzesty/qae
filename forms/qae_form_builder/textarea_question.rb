class QaeFormBuilder
  class TextareaQuestionValidator < QuestionValidator
    def errors
      result = super

      length = ActionView::Base.full_sanitizer.sanitize(question.input_value.to_s)
        .split(" ")
        .count { |a| a.present? }

      limit = question.delegate_obj.words_max

      if limit && limit_with_buffer(limit) && length && length > (limit_with_buffer(limit))
        result[question.hash_key] ||= ""
        error = if limit_with_buffer(limit) > 15
          " Question #{question.ref} has a word limit of #{limit}. Your answer has to be #{limit_with_buffer(limit)} words or less (as we allow 10% leeway)."
        else
          " Question #{question.ref} has a word limit of #{limit}. Your answer has to be #{limit_with_buffer(limit)} words or less."
        end
        result[question.hash_key] << error
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
