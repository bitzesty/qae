class QAEFormBuilder
  class AwardHolderQuestionBuilder < QuestionBuilder
    def year(name, years)
      @q.award_years = years
    end

    def details_words_max(value)
      @q.details_words_max = value
    end
  end

  class AwardHolderQuestion < Question
    attr_accessor :award_years, :details_words_max

    def after_create
      @award_years = []
    end
  end

  class AwardHolderQuestionDecorator < MultiQuestionDecorator
  end
end
