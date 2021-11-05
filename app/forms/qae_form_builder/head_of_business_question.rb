class QAEFormBuilder
  class HeadOfBusinessQuestionValidator < QuestionValidator
    NO_VALIDATION_SUB_FIELDS = [:honours]
    def errors
      result = super

      if question.required?
        question.required_sub_fields.each do |sub_field|
          suffix = sub_field.keys[0]
          if !question.input_value(suffix: suffix).present? && NO_VALIDATION_SUB_FIELDS.exclude?(suffix)
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

  class HeadOfBusinessQuestionDecorator < QuestionDecorator
    def required_sub_fields
      if sub_fields.present?
        sub_fields
      else
        [
          { title: "Title" },
          { first_name: "First name" },
          { last_name: "Last name" },
          { honours: "Personal Honours", ignore_validation: true },
          { job_title: "Job title / role in the organisation" },
          { email: "Email address" }
        ]
      end
    end

    def rendering_sub_fields
      # We are rejecting :honours, because :last_name and :honours
      # are rendering together in same block
      # and the :last_name is the first one
      required_sub_fields.reject do |f|
        f.keys.include?(:honours)
      end.map do |f|
        [f.keys.first, f.values.first]
      end
    end
  end

  class HeadOfBusinessQuestionBuilder < QuestionBuilder
    def sub_fields fields
      @q.sub_fields = fields
    end
  end

  class HeadOfBusinessQuestion < Question
    attr_accessor :sub_fields
  end

end
