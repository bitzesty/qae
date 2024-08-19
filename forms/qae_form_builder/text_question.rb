class QaeFormBuilder
  class TextQuestionValidator < QuestionValidator
  end

  class TextQuestionValidator < QuestionValidator
    def errors
      result = super

      length = question.input_value.to_s.split(" ").count { |element| element.present? }

      limit = question.delegate_obj.text_words_max

      if limit && length && length > limit
        result[question.hash_key] ||= ""
        result[question.hash_key] << " Exceeded #{limit} word limit."
      end

      if question.type == "website_url" && question.input_value && !valid_url?(question.input_value)
        result[question.hash_key] ||= ""
        result[question.hash_key] << " The website address is in an incorrect format. Use the format as shown in the description."
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
