module FeedbackPdfs::General::DataPointer
  def sub_category
    if sub_category_question.present?
      answer = filled_answers[sub_category_question.key]

      if answer.present?
        options = sub_category_question.ops_values

        selected_option = options.detect do |k, v|
          k == answer
        end[1]

        if selected_option == options.values.max
          "Continious"
        else
          "Outstanding"
        end
      end
    end
  end

  def sub_category_question
    all_questions.detect do |q|
      q.delegate_obj.is_a?(QAEFormBuilder::OptionsQuestion) &&
      q.sub_category_question.present?
    end
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
        feedback_data["#{key}_strength"] || UNDEFINED_VALUE,
        feedback_data["#{key}_weakness"] || UNDEFINED_VALUE
      ]
    end
  end

  def render_data!
    table_items = feedback_entries
    render_headers(feedback_table_headers)
    render_table(table_items)
  end
end
