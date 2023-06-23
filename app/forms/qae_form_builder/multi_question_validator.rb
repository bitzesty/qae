class QaeFormBuilder::MultiQuestionValidator < QaeFormBuilder::QuestionValidator
  def errors
    result = super

    question.entities.each_with_index do |entity, index|
      question.required_sub_fields_list.each do |attr|
        if !entity[attr].present?
          result[question.key] ||= {}
          result[question.key][index] ||= ""
          result[question.key][index] << " #{attr.humanize.capitalize} can't be blank."
        end
      end
    end

    result
  end
end
