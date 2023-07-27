class QAEFormBuilder
  class SubFieldsQuestionValidator < QuestionValidator
    NO_VALIDATION_SUB_FIELDS = [:honours]
    def errors
      result = super

      if question.required?
        question.required_sub_fields.each do |sub_field|
          suffix = sub_field.keys[0]
          if !question.input_value(suffix: suffix).present? && NO_VALIDATION_SUB_FIELDS.exclude?(suffix)
            result[question.hash_key(suffix: suffix)] ||= ""
            result[question.hash_key(suffix: suffix)] << "Question #{question.ref || question.sub_ref} is incomplete. #{suffix.to_s.humanize} is required and and must be filled in."
          end
        end
      end

      # need to add govuk-form-group--errors class
      result[question.hash_key] ||= "" if result.any?

      result
    end
  end

  class SubFieldsQuestionDecorator < QuestionDecorator
    def required_sub_fields
      sub_fields
    end

    def rendering_sub_fields
      required_sub_fields.map do |f|
        [f.keys.first, f.values.first]
      end
    end
  end

  class SubFieldsQuestionBuilder < QuestionBuilder
    def sub_fields fields
      @q.sub_fields = fields
    end
  end

  class SubFieldsQuestion < Question
    attr_accessor :sub_fields
  end

end
