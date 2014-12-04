class QAEFormBuilder

  class ConfirmQuestionBuilder < QuestionBuilder
    def text text
      @q.text = text
    end
  end

  class ConfirmQuestion < Question
    attr_accessor :text
  end

end
