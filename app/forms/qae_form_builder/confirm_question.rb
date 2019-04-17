class QAEFormBuilder
  class ConfirmQuestionValidator < QuestionValidator
  end

  class ConfirmQuestionBuilder < QuestionBuilder
    def text text
      @q.text = text
    end

    def pdf_text text
      @q.pdf_text = text
    end

    def post_checked_pdf_text text
      @q.post_checked_pdf_text = text
    end
  end

  class ConfirmQuestion < Question
    attr_writer :text

    attr_accessor :pdf_text, :post_checked_pdf_text

    def text
      if @text.respond_to?(:call)
        @text.call
      else
        @text
      end
    end
  end
end
