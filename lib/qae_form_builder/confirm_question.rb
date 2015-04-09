class QAEFormBuilder
  class ConfirmQuestionValidator < QuestionValidator
  end

  class ConfirmQuestionBuilder < QuestionBuilder
    def text text
      @q.text = text
    end
  end

  class ConfirmQuestion < Question
    attr_accessor :text
  end

end
