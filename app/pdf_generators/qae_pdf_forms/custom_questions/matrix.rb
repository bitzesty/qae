module QaePdfForms::CustomQuestions::Matrix
  def matrix_headers
    size = question.x_headings.length + 1

    ([question.corner_label] + question.x_headings.map(&:label)).flatten
  end

  def matrix_rows
    rows = question.y_headings.map do |y_heading|
      columns = ["#{y_heading.label}"]
      question.x_headings.each do |x_heading|
        columns << form_pdf.filled_answers[question.key.to_s + "_#{x_heading.key}_#{y_heading.key}"]
      end

      columns
    end

    total_row = ["#{question.totals_label}"]
    question.x_headings.each do |x_heading|
      total_row << form_pdf.filled_answers[question.key.to_s + "_#{x_heading.key}_total"]
    end

    rows << total_row

    rows
  end

  def render_matrix
    render_multirows_table(matrix_headers, matrix_rows, header: true)
  end
end
