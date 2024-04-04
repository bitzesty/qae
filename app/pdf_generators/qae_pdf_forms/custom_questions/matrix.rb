module QaePdfForms::CustomQuestions::Matrix
  def matrix_headers
    question.x_headings.map(&:label).unshift(question.corner_label)
  end

  def matrix_rows
    y_headings = if question.required_row_parent.present? && !question.required_row_options.blank?
      checked_options = form_pdf.filled_answers[question.required_row_parent].map(&:values).flatten
      question.y_headings.filter { |h| h.key.in?(checked_options) }
    else
      question.y_headings
    end

    rows = y_headings.map do |y_heading|
      columns = ["#{y_heading.label}"]
      question.x_headings.each do |x_heading|
        columns << form_pdf.filled_answers[question.key.to_s + "_#{x_heading.key}_#{y_heading.key}"]
      end

      columns
    end

    rows
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
      column_widths: millimeterized_column_widths
    }
  end

  def render_matrix
    render_multirows_table(matrix_headers, matrix_rows, matrix_options)
  end
end
