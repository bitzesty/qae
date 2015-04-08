module FeedbackPdfs::General::DataPointer
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
        data["#{key}_strength"] || UNDEFINED_VALUE,
        data["#{key}_weakness"] || UNDEFINED_VALUE
      ]
    end
  end

  def render_data!
    table_items = feedback_entries
    render_headers(feedback_table_headers)
    render_table(table_items)
  end
end
