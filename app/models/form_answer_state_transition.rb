class FormAnswerStateTransition
  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :state, String

  attr_accessor :form_answer, :subject

  def state
    @state ||= form_answer.state
  end

  def persisted?
    false
  end

  def save
    form_answer.state_machine.perform_transition(state, subject)
  end

  def collection
    form_answer.state_machine.collection(subject)
  end
end
