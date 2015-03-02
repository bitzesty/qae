class QAEFormBuilder

  class OrganizationAddressQuestionDecorator < QuestionDecorator
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

  class OrganizationAddressQuestionBuilder < QuestionBuilder
    def countries countries
      @q.countries = countries
    end
  end

  class OrganizationAddressQuestion < Question
    attr_accessor :countries
  end

end
