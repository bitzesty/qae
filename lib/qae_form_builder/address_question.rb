class QAEFormBuilder

  class AddressQuestionDecorator < QuestionDecorator
    def required_sub_fields
      [
        {building: "Building"},
        {street: "Street"},
        {city: "Town or city"},
        {country: "Country"},
        {postcode: "Postcode"}
      ]
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
