class QAEFormBuilder
  AwardHolderCategory = Struct.new(:value, :text)

  class AwardHolderQuestionBuilder < QuestionBuilder
    def year(name, years)
      @q.award_years = years
    end
  end

  class AwardHolderQuestion < Question
    attr_accessor :award_years

    def after_create
      @award_years = []
    end
  end

  class AwardHolderQuestionDecorator < MultiQuestionDecorator
  end
end
