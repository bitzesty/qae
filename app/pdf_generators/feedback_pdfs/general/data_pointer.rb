module FeedbackPdfs::General::DataPointer
  def undefined_value
    FeedbackPdfs::Pointer::UNDEFINED_VALUE
  end

  def feedback_table_headers
    [
      [
        "",
        "Key strengths",
        "Information to strengthen the application"
      ]
    ]
  end

  def feedback_entries
    FeedbackForm.fields_for_award_type(form_answer.award_type).map do |key, value|
      [
        value[:label].gsub(":", ""),
        data["#{key}_strength"] || undefined_value,
        data["#{key}_weakness"] || undefined_value
      ]
    end
  end

  def render_data!
    table_items = feedback_entries

    render_overall_summary!
    render_headers(feedback_table_headers, {
      0 => 130,
      1 => 300,
      2 => 337
    })
    render_table(table_items, {
      0 => 130,
      1 => 300,
      2 => 337
    })
  end

  def render_overall_summary!
    pdf_doc.move_down 30.mm
    render_table([["Overall Summary", data["overall_summary"]]], {
      0 => 130,
      1 => 637
    })
  end

  def render_headers(table_lines, column_widths)
    pdf_doc.move_down 10.mm
    pdf_doc.table table_lines, row_colors: %w(F0F0F0),
                               cell_style: { size: 12, font_style: :bold },
                               column_widths: column_widths
  end
end
