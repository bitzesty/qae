class QaeFormBuilder
  class UserInfoQuestionValidator < QuestionValidator
    def errors
      result = super

      if question.required?
        question.required_sub_fields.each do |sub_field|
          suffix = sub_field.keys[0]
          if question.input_value(suffix: suffix).blank?
            result[question.hash_key(suffix: suffix)] ||= ""
            result[question.hash_key(suffix: suffix)] << " Can't be blank."
          end
        end
      end

      # need to add govuk-form-group--errors class
      result[question.hash_key] ||= "" if result.any?

      result
    end
  end

  class UserInfoQuestionDecorator < QuestionDecorator
    def required_sub_fields
      sub_fields
    end

    def rendering_sub_fields
      sub_fields.map do |f|
        [f.keys.first, f.values.first]
      end
    end
  end

  class UserInfoQuestionBuilder < QuestionBuilder
    def sub_fields fields = []
      @q.sub_fields = fields
    end
  end

  class UserInfoQuestion < Question
    attr_accessor :sub_fields
  end
end
