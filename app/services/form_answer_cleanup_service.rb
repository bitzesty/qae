class FormAnswerCleanupService
  attr_reader :form_answer, :answers, :award_form, :processed_answers

  def initialize(form_answer)
    @form_answer = form_answer
    @answers = HashWithIndifferentAccess.new(form_answer.document)
    @award_form = form_answer.award_form.decorate(answers: answers)
    @current_step = form_answer.current_step
    @processed_answers = {}
  end

  def perform!
    award_form.steps.each do |step|
      step.questions.each do |q|
        if q.visible?
          @processed_answers[q.key.to_s] = answers[q.key]

          # since method_missing is used to fetch a sub_fields
          # we can't check with if subfields are available with `respond_to?`
          sub_fields = begin
            q.sub_fields
          rescue NoMethodError
            []
          end

          required_sub_fields = begin
            q.required_sub_fields
          rescue NoMethodError
            []
          end

          (sub_fields + required_sub_fields).each do |sub_field|
            key = "#{q.key}_#{sub_field.keys[0]}"

            @processed_answers[key] = answers[key]
          end

          next
        end

        if question_answers = answers[q.key]
          case question_answers
          when Array
            cleaned_answers = question_answers.map do |qa|
              qa.keys.inject({}) { |hash, key| hash.merge(key => "") }
            end

            @processed_answers[q.key.to_s] = cleaned_answers
          when String
            @processed_answers[q.key.to_s] = nil
          end
        end
      end
    end
  end
end
