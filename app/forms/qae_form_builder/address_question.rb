class QaeFormBuilder
  class AddressQuestionValidator < QuestionValidator
    NO_VALIDATION_SUB_FIELDS = [:street, :county]
    def errors
      result = super

      if question.required?
        question.required_sub_fields.each do |sub_field|
          suffix = sub_field.keys[0]
          if !question.input_value(suffix: suffix).present? && NO_VALIDATION_SUB_FIELDS.exclude?(suffix)
            result[question.hash_key(suffix: suffix)] ||= ""
            result[question.hash_key(suffix: suffix)] << " Can't be blank."
          end
        end
      end

      # need to add govuk-form-group--errors class
      result[question.hash_key] ||= "" if result.any?

      result
    end
  end

  class AddressQuestionDecorator < QuestionDecorator
    include RegionHelper

    def required_sub_fields
      if sub_fields.present?
        sub_fields
      else
        [
          { building: "Building" },
          { street: "Street", ignore_validation: true },
          { city: "Town or city" },
          { country: "Country" },
          { postcode: "Postcode" }
        ]
      end
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
    def countries(countries)
      @q.countries = countries
    end

    def sub_fields(fields)
      @q.sub_fields = fields
    end

    def region_context(region_context)
      @q.region_context = region_context
    end

    def county_context(county_context)
      @q.county_context = county_context
    end
  end

  class AddressQuestion < Question
    attr_accessor :countries, :sub_fields, :region_context, :county_context
  end
end
