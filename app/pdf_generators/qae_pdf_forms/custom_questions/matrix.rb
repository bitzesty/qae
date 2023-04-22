module QaePdfForms::CustomQuestions::Matrix
  def matrix_headers
    question.x_headings.map(&:label).unshift(question.corner_label)
  end

  def matrix_rows
    rows = question.y_headings.map do |y_heading|
      columns = ["#{y_heading.label}"]
      question.x_headings.each do |x_heading|
        columns << form_pdf.filled_answers[question.key.to_s + "_#{x_heading.key}_#{y_heading.key}"]
      end

      columns
    end

    subtotal_row = ["#{question.subtotals_label}"]
    others_row = ["#{question.others_label}"]
    total_row = ["#{question.totals_label}"]
    proportion_row = ["#{question.proportion_label}"]
    question.x_headings.each do |x_heading|
      others_row << form_pdf.filled_answers[question.key.to_s + "_#{x_heading.key}_others_receiving_support"]
    end
    question.x_headings.each do |x_heading|
      total_row << form_pdf.filled_answers[question.key.to_s + "_#{x_heading.key}_total"]
    end
    question.x_headings.each do |x_heading|
      subtotal_row << form_pdf.filled_answers[question.key.to_s + "_#{x_heading.key}_subtotal"]
    end
    question.x_headings.each do |x_heading|
      proportion_row << form_pdf.filled_answers[question.key.to_s + "_#{x_heading.key}_proportion"]
    end
    
    rows << subtotal_row if subtotal_row.any?(&:present?)
    rows << others_row if others_row.any?(&:present?)
    rows << total_row if total_row.any?(&:present?)
    rows << proportion_row if proportion_row.any?(&:present?)

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
