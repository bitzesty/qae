class QAEFormBuilder
  class SubsidiariesAssociatesPlantsQuestionValidator < QuestionValidator
    def errors
      result = super

      question.subsidiaries.each_with_index do |award, index|
        question.required_sub_fields_list.each do |attr|
          if !award[attr].present?
            result[question.key] ||= {}
            result[question.key][index] ||= ""
            result[question.key][index] << " #{attr.humanize.capitalize} can't be blank."
          end
        end
      end

      result
    end
  end

  class SubsidiariesAssociatesPlantsQuestionBuilder < QuestionBuilder
  end

  class SubsidiariesAssociatesPlantsQuestion < Question
  end

  class SubsidiariesAssociatesPlantsQuestionDecorator < QuestionDecorator
    def subsidiaries
      @subsidiaries ||= JSON.parse(answers[delegate_obj.key.to_s] || '[]').map do |answer|
        JSON.parse(answer)
      end
    end

    def required_sub_fields_list
      %w(name location employees)
    end
  end
end
