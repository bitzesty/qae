class QaeFormBuilder
  class YearQuestionValidator < QuestionValidator
    def errors
      result = super

      if question.required?
        if !question.input_value.present?
          result[question.hash_key] ||= ""
          result[question.hash_key] = "Question #{question.ref || question.sub_ref} is incomplete. It is required and and must be filled in. Use the format YYYY."
        end
      end

      year = question.input_value.to_i
      year_max = question.max.respond_to?(:call) ? question.max.call : question.max
      if year < question.min || (year_max && year > year_max)
        result[question.hash_key] = "The year needs to be between #{question.min} and the current year. Any project that started before that would not be considered an innovation."
      end

      result
    end
  end

  class YearQuestionDecorator < QuestionDecorator
    def fieldset_classes
      result = super
      result << "question-year"
      result
    end
  end

  class YearQuestionBuilder < QuestionBuilder
    def min num
      @q.min = num
    end

    def max num
      @q.max = num
    end
  end

  class YearQuestion < Question
    attr_accessor :min, :max
  end
end
