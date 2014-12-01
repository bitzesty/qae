class QAEFormBuilder

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
  end

  class NumberQuestion < TextQuestion
    attr_accessor :min, :max
  end

end
