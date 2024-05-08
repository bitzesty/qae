class QaeFormBuilder
  class NumberQuestionValidator < QuestionValidator
  end

  class NumberQuestionDecorator < QuestionDecorator
    def fieldset_classes
      result = super
      result << "question-number"
      result
    end
  end

  class NumberQuestionBuilder < TextQuestionBuilder
    def initialize q
      super q
      q.type = :number
    end

    def min num
      @q.min = num
    end

    def max num
      @q.max = num
    end

    def unit unit
      @q.unit = unit
    end
  end

  class NumberQuestion < TextQuestion
    attr_accessor :min, :max, :unit
  end

end
