class QAEFormBuilder

  class AddressQuestionDecorator < QuestionDecorator
    COUNTIES = [
      "East",
      "East Midlands",
      "West Midlands",
      "London",
      "North East",
      "North West",
      "South East",
      "South West",
      "Yorkshire and the Humber",
      "Channel Islands",
      "Isle of Man",
      "Northern Ireland",
      "Scotland",
      "Wales"
    ]

    def required_sub_fields
      if sub_fields.present?
        sub_fields
      else
        [
          { building: "Building" },
          { street: "Street" },
          { city: "Town or city" },
          { country: "Country" },
          { county: "County" },
          { postcode: "Postcode" }
        ]
      end
    end

    def counties
      COUNTIES
    end

    def rendering_sub_fields
      # We are rejecting :street, because :building and :street
      # are rendering together in same block
      # and the :building is the first one
      required_sub_fields.reject do |f|
        f.keys.include?(:street)
      end.map do |f|
        [f.keys.first, f.values.first]
      end
    end
  end

  class AddressQuestionBuilder < QuestionBuilder
    def countries countries
      @q.countries = countries
    end

    def sub_fields fields
      @q.sub_fields = fields
    end
  end

  class AddressQuestion < Question
    attr_accessor :countries, :sub_fields
  end
end
