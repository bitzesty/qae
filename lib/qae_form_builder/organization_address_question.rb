class QAEFormBuilder

  class OrganizationAddressQuestionDecorator < QuestionDecorator
    def required_sub_fields
      [
        {name: "Name"},
        {building: "Building"},
        {street: "Street"},
        {city: "Town or city"},
        {country: "Country"},
        {postcode: "Postcode"},
        {website_url: "Website URL"}
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
