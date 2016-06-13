class QAEFormBuilder
  class RegionsQuestionValidator < DropdownQuestionValidator
  end

  class RegionsQuestionBuilder < DropdownQuestionBuilder
  end

  class RegionsQuestionDecorator < QuestionDecorator
    def regions
      ::QAEFormBuilder::AddressQuestionDecorator::REGIONS
    end

    def entities
      @entities ||= (answers[delegate_obj.key.to_s] || [])
    end
  end
  class RegionsQuestion < DropdownQuestion
  end
end
