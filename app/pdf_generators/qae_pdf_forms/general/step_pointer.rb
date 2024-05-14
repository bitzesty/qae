class QaePdfForms::General::StepPointer
  attr_reader :award_form,
    :form_pdf,
    :step,
    :step_questions,
    :filtered_questions

  def initialize(ops = {})
    ops.each do |k, v|
      instance_variable_set(:"@#{k}", v)
    end

    @step_questions = step.questions.reject do |question|
      FormPdf::HIDDEN_QUESTIONS.include?(question.key.to_s)
    end

    # When we are displaying only visible questions (in accordance with conditions) use:
    #
    # @filtered_questions = step_questions.select do |question|
    #   award_form[question.key].visible?
    # end
    #
    # If need to show all questions use:
    # @filtered_questions = step_questions

    @filtered_questions = step_questions
  end

  def render!
    form_pdf.start_new_page if step.index.to_i != 0
    form_pdf.render_header("#{step.title.upcase}:")

    filtered_questions.each do |question|
      QaePdfForms::General::QuestionPointer.new(form_pdf: form_pdf,
        step: self,
        question: question.decorate).render!
    end
  end
end
