class QAEFormBuilder
  class HeaderQuestionDecorator < QuestionDecorator
    def pdf_located_before
      delegate_obj.pdf_located_before
    end
  end

  class HeaderQuestionBuilder < QuestionBuilder
    def pdf_located_before q_key
      @q.pdf_located_before = q_key
    end
  end

  class HeaderQuestion < Question
    attr_accessor :pdf_located_before
  end

end
