class QAEFormBuilder
  class AwardHolderQuestionValidator < QuestionValidator
  end

  class AwardHolderQuestionBuilder < QuestionBuilder
    def award_years_present(value)
      @q.award_years_present = value
    end

    def details_words_max(value)
      @q.details_words_max = value
    end
  end

  class AwardHolderQuestion < Question
    attr_accessor :award_years_present, :details_words_max
  end

  class AwardHolderQuestionDecorator < MultiQuestionDecorator
  end
end
