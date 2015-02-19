class QAEFormBuilder
  class HeaderQuestionDecorator < QuestionDecorator
    def show_in_pdf_before
      delegate_obj.show_in_pdf_before
    end
  end

  class HeaderQuestionBuilder < QuestionBuilder
    def show_in_pdf_before dependable_question_keys=[]
      @q.show_in_pdf_before = dependable_question_keys
    end
  end

  class HeaderQuestion < Question
    attr_accessor :show_in_pdf_before

    def after_create
      @show_in_pdf_before = []
    end
  end
end
