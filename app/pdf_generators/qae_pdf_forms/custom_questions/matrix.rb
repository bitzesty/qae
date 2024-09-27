module QaePdfForms::CustomQuestions::Matrix
  def matrix_headers
    question.x_headings.map(&:label).unshift(question.corner_label)
  end

  def matrix_rows
    y_headings = if question.required_row_parent.present? && question.required_row_options.present?
      checked_options = form_pdf.filled_answers.fetch(question.required_row_parent, []).map(&:values).flatten
      if checked_options.size.zero?
        question.y_headings
      else
        question.y_headings.filter do |h|
          h.key.in?(checked_options) || h.key.in?(QaeFormBuilder::AUTO_CALCULATED_HEADINGS)
        end
      end
    else
      question.y_headings
    end

    y_headings.map do |y_heading|
      columns = [y_heading.label.to_s]
      question.x_headings.each do |x_heading|
        if y_heading.key.in?(QaeFormBuilder::AUTO_CALCULATED_HEADINGS)
          question.assign_autocalculated_value(question.key, question.x_headings, question.y_headings, form_pdf.filled_answers, x_heading.key, y_heading.key, key: y_heading.key)
        end

        columns << form_pdf.filled_answers["#{question.key}_#{x_heading.key}_#{y_heading.key}"]
      end

      columns
    end
  end

  def millimeterized_column_widths
    (question.column_widths || {}).transform_values do |value|
      if value.respond_to?(:mm)
        value.public_send(:mm)
      else
        value
      end
    end
  end

  def matrix_options
    {
      header: true,
      column_widths: millimeterized_column_widths,
    }
  end

  def render_matrix
    render_multirows_table(matrix_headers, matrix_rows, matrix_options) if matrix_rows.size.positive?
  end
end
