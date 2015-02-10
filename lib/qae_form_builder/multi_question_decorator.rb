class QAEFormBuilder::MultiQuestionDecorator < QAEFormBuilder::QuestionDecorator
  def awards
    @awards ||= JSON.parse(answers[delegate_obj.key.to_s] || '[]').map { |answer| JSON.parse(answer) }
  end
end
