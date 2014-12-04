class QAEFormBuilder

  class AddressQuestionBuilder < QuestionBuilder
    def countries countries
      @q.countries = countries
    end
  end

  class AddressQuestion < Question
    attr_accessor :countries
  end

end
