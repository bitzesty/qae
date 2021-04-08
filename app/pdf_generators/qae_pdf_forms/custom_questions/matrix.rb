module QaePdfForms::CustomQuestions::Matrix
  def matrix_headers
    size = question.x_headings.length + 1

    ([question.corner_label] + question.x_headings.map(&:label)).flatten
  end

  def matrix_rows
    rows = question.y_headings.map do |y_heading|
      columns = Array.new(question.x_headings.length + 1, "")
      columns[0] = "#{y_heading.label}"
      columns
    end

    total_row = Array.new(question.x_headings.length + 1, "")
    total_row[0] = "#{question.totals_label}"

    rows << total_row

    rows
  end

  def render_matrix
    render_multirows_table(matrix_headers, matrix_rows)
  end
end
