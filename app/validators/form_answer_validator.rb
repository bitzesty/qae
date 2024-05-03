class FormAnswerValidator
  attr_reader :award_form, :form_answer, :current_step, :errors

  def initialize(form_answer)
    @form_answer = form_answer

    answers = HashWithIndifferentAccess.new(form_answer.document)
    @award_form = form_answer.award_form.decorate(answers:)
    @current_step = form_answer.current_step

    @errors = {}
  end

  def valid?
    form_answer.steps_with_errors = []

    award_form.steps.each do |step|
      # if form was submitted before
      # or it's a non-js form
      # we should validate current step
      # else if form was submitted just now
      # we should validate entire form

      non_js_save = step.title.parameterize == form_answer.current_non_js_step && form_answer.submitted_at.nil?

      unless step.title.parameterize == current_step || non_js_save || (form_answer.submitted_at_changed? && form_answer.submitted_at_was.nil?)
        next
      end

      step.questions.each do |q|
        if (errors = q.validate).any?
          @errors.merge!(errors)
          form_answer.steps_with_errors << step.title.parameterize
        end
      end
    end

    @errors.none?
  end
end
