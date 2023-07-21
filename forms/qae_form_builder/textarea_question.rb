class QaeFormBuilder
  class TextareaQuestionValidator < QuestionValidator
    def errors
      result = super

      length = ActionView::Base.full_sanitizer.sanitize(
        question.input_value.to_s
      ).split(" ")
       .reject do |a|
        a.blank?
      end.length

      limit = question.delegate_obj.words_max

      if limit && limit_with_buffer(limit) && length && length > limit_with_buffer(limit)
        result[question.hash_key] ||= ""
        result[question.hash_key] << " Exceeded #{limit} words limit."
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
