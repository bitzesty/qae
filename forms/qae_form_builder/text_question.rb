class QaeFormBuilder
  class TextQuestionValidator < QuestionValidator
  end

  class TextQuestionValidator < QuestionValidator
    def errors
      result = super

      length = question.input_value.to_s.split(" ").reject(&:blank?).length

      limit = question.delegate_obj.text_words_max

      if limit && length && length > limit
        result[question.hash_key] ||= ""
        result[question.hash_key] << " Exceeded #{limit} word limit."
      end

      result
    end
  end

  class TextQuestionBuilder < QuestionBuilder
    def text_words_max(value)
      @q.text_words_max = value
    end

    def style style
      @q.style = style
    end

    def type type
      @q.type = type
    end
  end

  class TextQuestion < Question
    attr_accessor :type, :style, :text_words_max
  end

end
