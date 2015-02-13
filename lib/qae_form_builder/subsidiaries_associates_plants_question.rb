class QAEFormBuilder

  class SubsidiariesAssociatesPlantsQuestionBuilder < QuestionBuilder
  end

  class SubsidiariesAssociatesPlantsQuestion < Question
  end

  class SubsidiariesAssociatesPlantsQuestionDecorator < MultiQuestionDecorator
    def subsidiaries
      @subsidiaries ||= JSON.parse(answers[delegate_obj.key.to_s] || '[]').map do |answer| 
        JSON.parse(answer)
      end
    end
  end
end
