class QaeFormBuilder::MultiQuestionDecorator < QaeFormBuilder::QuestionDecorator
  def entities
    @entities ||= (answers[delegate_obj.key.to_s] || [])
  end
end
