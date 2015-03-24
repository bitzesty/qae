class QaePdfForms::General::StepPointer
  attr_reader :award_form,
              :form_pdf,
              :step,
              :step_questions,
              :filtered_questions

  def initialize(ops = {})
    ops.each do |k, v|
      instance_variable_set("@#{k}", v)
    end

    @step_questions = step.questions.reject do |question|
      FormPdf::HIDDEN_QUESTIONS.include?(question.key.to_s)
    end

    @filtered_questions = step_questions.select do |question|
      award_form[question.key].visible?
    end
  end

  def render!
    form_pdf.start_new_page if step.index.to_i != 0
    render_header

    filtered_questions.each do |question|
      QaePdfForms::General::QuestionPointer.new(form_pdf: form_pdf,
                                                step: self,
                                                question: question.decorate).render!
    end
  end

  def render_header
    form_pdf.text "#{step.title.upcase}:",
                  style: :bold,
                  size: 16,
                  align: :left
    form_pdf.stroke_color = "999999"
    form_pdf.move_down 4.mm
    form_pdf.stroke_horizontal_line 0, 192.mm
    form_pdf.default_bottom_margin
  end
end
