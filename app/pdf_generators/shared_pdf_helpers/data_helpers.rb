module SharedPdfHelpers::DataHelpers
  def sub_category
    if sub_category_question.present?
      answer = filled_answers[sub_category_question.key]

      if answer.present?
        options = sub_category_question.ops_values

        selected_option = options.detect do |k, v|
          k == answer
        end[1]

        if selected_option == options.values.max
          "Continuous"
        else
          "Outstanding"
        end
      end
    end
  end

  def sub_category_question
    all_questions.detect do |q|
      q.delegate_obj.is_a?(QaeFormBuilder::OptionsQuestion) &&
        q.sub_category_question.present?
    end
  end
end
