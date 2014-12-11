class QAEFormBuilder

  class UploadQuestionBuilder < QuestionBuilder
    def max_attachments num
      @q.max_attachments = num
    end
  end

  class UploadQuestion < Question
    attr_accessor :max_attachments
  end

end
