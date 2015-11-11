class QAEFormBuilder
  class SubsidiariesAssociatesPlantsQuestionValidator < MultiQuestionValidator
  end

  class SubsidiariesAssociatesPlantsQuestionBuilder < QuestionBuilder
  end

  class SubsidiariesAssociatesPlantsQuestion < Question
  end

  class SubsidiariesAssociatesPlantsQuestionDecorator < QuestionDecorator
    def subsidiaries
      @subsidiaries ||= (answers[delegate_obj.key.to_s] || [])
    end

    alias :entities :subsidiaries

    def required_sub_fields_list
      %w(name location employees)
    end
  end
end
