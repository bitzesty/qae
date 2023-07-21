class QaeFormBuilder
  class HeaderQuestionValidator < QuestionValidator
    def errors
      {}
    end
  end

  class HeaderQuestionBuilder < QuestionBuilder
    # adds a header to a submenu
    def linkable(val)
      @q.linkable = !!val
    end
  end

  class HeaderQuestion < Question
    attr_accessor :linkable

    def linkable?
      linkable == true
    end
  end
end
