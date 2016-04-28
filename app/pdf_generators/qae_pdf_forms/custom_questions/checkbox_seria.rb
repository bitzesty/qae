module QaePdfForms::CustomQuestions::CheckboxSeria
  def render_checkbox_selected_values
    title = if q_visible? && humanized_answer.present?
      humanized_answer.map do |option|
        checkbox_possible_ops.detect do |p_o|
          p_o[0].to_s == option["type"].to_s
        end[1]
      end.join(", ")
    else
      "#{FormPdf::NOTHING_SELECTED} from #{checkbox_possible_ops_titles}!"
    end

    form_pdf.indent 7.mm do
      form_pdf.font("Times-Roman") do
        form_pdf.render_text title, color: FormPdf::DEFAULT_ANSWER_COLOR
      end
    end
  end

  def checkbox_possible_ops
    question.check_options
  end

  def checkbox_possible_ops_titles
    checkbox_possible_ops.map do |option|
      option[1]
    end.map do |p_o_title|
      "'#{p_o_title}'"
    end.join(" / ")
  end
end
