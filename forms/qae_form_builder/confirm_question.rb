class QaeFormBuilder
  class ConfirmQuestionValidator < QuestionValidator
    def errors
      result = {}

      return {} if skip_base_validation?

      if question.required?
        if !question.input_value.present?
          result[question.hash_key] = "Question #{question.ref || question.sub_ref} is incomplete. It is required and confirmation must be given by ticking the checkbox."
        end
      end

      result
    end
  end

  class ConfirmQuestionBuilder < QuestionBuilder
    def text text
      @q.text = text
    end

    def pdf_text text
      @q.pdf_text = text
    end
  end

  class ConfirmQuestion < Question
    attr_writer :text

    attr_accessor :pdf_text

    def text
      if @text.respond_to?(:call)
        @text.call
      else
        @text
      end
    end
  end
end
