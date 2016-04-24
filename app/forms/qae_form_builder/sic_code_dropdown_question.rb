class QAEFormBuilder
  class SicCodeDropdownQuestionValidator < QuestionValidator
  end

  class SicCodeDropdownQuestionBuilder < DropdownQuestionBuilder
  end

  class SicCodeDropdownQuestion < DropdownQuestion
    def options
      return @options if @options.any?

      @options = SICCode.collection.map do |text, value|
        QuestionAnswerOption.new(value, text)
      end
    end
  end
end
