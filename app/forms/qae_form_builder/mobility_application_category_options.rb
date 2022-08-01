class QAEFormBuilder
  class MobilityApplicationCategoryOptionsQuestionValidator < OptionsQuestionValidator
    def errors
      result = super

      if question.answers[question.key] == "organisation"
        result[question.key] = "You can only apply on the basis of having an initiative which promotes opportunity through social mobility. As per our eligibility questionnaire and information listed on our website, we are no longer accepting applications for organisations whose sole purpose is promoting opportunity through Social Mobility."
      end

      result
    end
  end

  class MobilityApplicationCategoryOptionsQuestionBuilder < OptionsQuestionBuilder
  end

  class MobilityApplicationCategoryOptionsQuestion < OptionsQuestion
  end
end
