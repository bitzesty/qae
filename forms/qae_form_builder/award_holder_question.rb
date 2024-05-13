class QaeFormBuilder
  class AwardHolderQuestionValidator < QuestionValidator
    def errors
      result = super

      question.entities.each_with_index do |award, index|
        question.required_sub_fields_list.each do |attr|
          if !award[attr].present?
            result[question.key] ||= {}
            result[question.key][index] ||= ""
            result[question.key][index] << " #{attr.humanize.capitalize} can't be blank."
          elsif attr == "details"
            limit = question.delegate_obj.details_words_max
            length = award[attr].split(" ").length

            if limit && limit_with_buffer(limit) && length && length > limit_with_buffer(limit)
              result[question.key][index] ||= ""
              result[question.key][index] << " #{attr.humanize.capitalize} exeeded #{limit} words limit."
            end
          end
        end
      end

      result
    end
  end

  class AwardHolderQuestionBuilder < QuestionBuilder
    def award_years_present(value)
      @q.award_years_present = value
    end

    def details_words_max(value)
      @q.details_words_max = value
    end
  end

  class AwardHolderQuestion < Question
    attr_accessor :award_years_present, :details_words_max
  end

  class AwardHolderQuestionDecorator < MultiQuestionDecorator
    def required_sub_fields_list
      if delegate_obj.award_years_present
        %w(title year details)
      else
        %w(title details)
      end
    end
  end
end
