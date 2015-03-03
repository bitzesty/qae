class QAEFormBuilder
  class ShowHideNoteQuestionBuilder < QuestionBuilder
    def note text
      @q.note = text
    end

    def description text
      @q.description = text
    end
  end

  class ShowHideNoteQuestion < Question
    attr_accessor :note, :description
  end
end
