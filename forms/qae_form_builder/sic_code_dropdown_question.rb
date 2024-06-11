class QaeFormBuilder
  class SicCodeDropdownQuestionValidator < QuestionValidator
    def errors
      result = super

      if question.required?
        if question.input_value.blank?
          result[question.hash_key] ||= ""
          result[question.hash_key] = "Question #{question.ref || question.sub_ref} is incomplete. It is required and and an option must be selected from the following dropdown list."
        end
      end

      result
    end
  end

  class SicCodeDropdownQuestionBuilder < DropdownQuestionBuilder
  end

  class SicCodeDropdownQuestion < DropdownQuestion
    def options
      return @options if @options.any?

      @options = SicCode.collection.map do |text, value|
        QuestionAnswerOption.new(value, text)
      end
    end
  end
end
