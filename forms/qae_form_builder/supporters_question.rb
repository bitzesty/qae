class QaeFormBuilder
  class SupportersQuestionValidator < QuestionValidator
    MIN_LIMIT = 2

    def errors
      result = super

      supporters = question.answers["supporters"] || {}
      letters = question.answers["supporter_letters_list"] || {}

      count = calculate_without_blanks(supporters)

      count += calculate_without_blanks(letters) if question.answers["manually_upload"] == "yes"

      result["supporters"] = "You need to provide at least 2 letters of support" if count < MIN_LIMIT

      result
    end

    private

    def calculate_without_blanks(supporters)
      supporters.count do |sup|
        sup["support_letter_id"].present? || sup["supporter_id"].present?
      end
    end
  end

  class SupportersQuestionBuilder < QuestionBuilder
    def limit(value)
      @q.limit = value
    end

    def default(value)
      @q.default = value
    end

    def list_type(list_type)
      @q.list_type = list_type
    end
  end

  class SupportersQuestion < Question
    attr_accessor :limit, :default, :list_type
  end

  class SupportersQuestionDecorator < MultiQuestionDecorator
  end
end
