class QaeFormBuilder::MultiQuestionValidator < QaeFormBuilder::QuestionValidator
  def errors
    result = super

    question.entities.each_with_index do |entity, index|
      question.required_sub_fields_list.each do |attr|
        if entity[attr].blank?
          result[question.key] ||= {}
          result[question.key][index] ||= ""
          result[question.key][index] << "Question #{question.ref || question.sub_ref} is incomplete. #{attr.humanize} can't be blank."
        end
      end
    end

    result
  end
end
