class QaeFormBuilder
  class CommentQuestionValidator < QuestionValidator
    def errors
      {}
    end
  end

  class CommentQuestionBuilder < QuestionBuilder
  end

  class CommentQuestion < Question
  end
end
