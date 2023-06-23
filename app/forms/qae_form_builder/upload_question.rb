class QaeFormBuilder
  class UploadQuestionValidator < QuestionValidator
  end

  class UploadQuestionBuilder < QuestionBuilder
    def max_attachments num
      @q.max_attachments = num
    end

    def links
      @q.links = true
    end
    def description
      @q.description = true
    end
  end

  class UploadQuestion < Question
    attr_accessor :max_attachments, :links, :description
  end

end
