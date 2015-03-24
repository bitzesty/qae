class FormAnswerTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  belongs_to :form_answer, inverse_of: :form_answer_transitions

  def transitable
    metadata["transitable_type"].constantize.find(metadata["transitable_id"])
  end
end
