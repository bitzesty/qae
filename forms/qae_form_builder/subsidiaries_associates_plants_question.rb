class QaeFormBuilder
  class SubsidiariesAssociatesPlantsQuestionValidator < MultiQuestionValidator
  end

  class SubsidiariesAssociatesPlantsQuestionBuilder < QuestionBuilder
    def details_words_max(value)
      @q.details_words_max = value
    end
  end

  class SubsidiariesAssociatesPlantsQuestion < Question
    attr_accessor :details_words_max
  end

  class SubsidiariesAssociatesPlantsQuestionDecorator < QuestionDecorator
    def subsidiaries
      @subsidiaries ||= answers[delegate_obj.key.to_s] || []
    end

    alias :entities :subsidiaries

    def required_sub_fields_list
      %w(name location employees)
    end
  end
end
