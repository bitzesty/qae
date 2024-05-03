class QaeFormBuilder
  class AddressQuestionValidator < SubFieldsQuestionValidator
  end

  class AddressQuestionDecorator < SubFieldsQuestionDecorator
    include RegionHelper
    NO_VALIDATION_SUB_FIELDS = %i[street county]

    def required_sub_fields
      if sub_fields.present?
        sub_fields.select do |f|
          NO_VALIDATION_SUB_FIELDS.exclude?(f.keys.first)
        end
      else
        [
          { building: "Building" },
          { street: "Street", ignore_validation: true },
          { city: "Town or city" },
          { country: "Country" },
          { postcode: "Postcode" },
        ]
      end
    end

    def rendering_sub_fields
      # We are rejecting :street, because :building and :street
      # are rendering together in same block
      # and the :building is the first one
      sub_fields.reject do |f|
        f.keys.include?(:street)
      end.map do |f|
        [f.keys.first, f.values.first]
      end
    end
  end

  class AddressQuestionBuilder < SubFieldsQuestionBuilder
    def countries(countries)
      @q.countries = countries
    end

    def region_context(region_context)
      @q.region_context = region_context
    end

    def county_context(county_context)
      @q.county_context = county_context
    end
  end

  class AddressQuestion < SubFieldsQuestion
    attr_accessor :countries, :sub_fields, :region_context, :county_context
  end
end
