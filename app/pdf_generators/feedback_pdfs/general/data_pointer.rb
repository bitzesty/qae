module FeedbackPdfs::General::DataPointer
  def undefined_value
    FeedbackPdfs::Pointer::UNDEFINED_VALUE
  end

  def feedback_table_headers
    [
      [
        "Overall Summary",
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
    render_headers(feedback_table_headers)
    render_table(table_items, {
      0 => 100,
      1 => 100,
      2 => 567
    })
  end
end
