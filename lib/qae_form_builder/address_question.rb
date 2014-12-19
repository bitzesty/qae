class QAEFormBuilder

  class AddressQuestionDecorator < QuestionDecorator
    def required_suffixes
      [:building, :street, :city, :country, :postcode]
    end
  end

  class AddressQuestionBuilder < QuestionBuilder
    def countries countries
      @q.countries = countries
    end
  end

  class AddressQuestion < Question
    attr_accessor :countries
  end

end
