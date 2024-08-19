class QaeFormBuilder
  class RegionsQuestionValidator < DropdownQuestionValidator
    def errors
      result = super

      if question.required?
        if question.input_value.empty?
          result[question.hash_key] = "Can't be blank."
        elsif question.input_value.any? { |v| v.present? && question.regions.exclude?(v) }
          result[question.hash_key] = "Is not a valid region."
        end
      end

      result
    end
  end

  class RegionsQuestionBuilder < DropdownQuestionBuilder
  end

  class RegionsQuestionDecorator < QuestionDecorator
    def regions
      ::QaeFormBuilder::AddressQuestionDecorator::REGIONS.sort
    end

    def entities
      @entities ||= answers[delegate_obj.key.to_s] || []
    end
  end

  class RegionsQuestion < DropdownQuestion
  end
end
