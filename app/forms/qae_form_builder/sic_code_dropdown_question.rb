class QaeFormBuilder
  class SicCodeDropdownQuestionValidator < QuestionValidator
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
