class QaePdfForms::General::StepPointer
  attr_reader :award_form,
              :form_pdf,
              :step,
              :step_headers,
              :step_questions,
              :filtered_questions

  def initialize(ops={})
    ops.each do |k, v|
      instance_variable_set("@#{k}", v)
    end

    @step_questions = step.questions.reject do |question|
      FormPdf::HIDDEN_QUESTIONS.include?(question.key.to_s)
    end

    @filtered_questions = step_questions.select do |question|
      award_form[question.key].visible?
    end

    @step_headers = step_questions.select do |question|
      question.delegate_obj.is_a?(QAEFormBuilder::HeaderQuestion) &&
      question.show_in_pdf_before.present?
    end
  end

  def render!
    form_pdf.start_new_page if step.index.to_i != 0
    render_header

    filtered_questions.each do |question|
      QaePdfForms::General::QuestionPointer.new({
        form_pdf: form_pdf,
        step: self,
        question: question.decorate
      }).render!
    end
  end

  def render_header
    form_pdf.text step.complex_title, style: :bold, 
                                  size: 18, 
                                  align: :left
    form_pdf.default_bottom_margin
  end
end