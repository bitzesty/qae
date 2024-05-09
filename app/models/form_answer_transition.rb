class FormAnswerTransition < ApplicationRecord
  include Statesman::Adapters::ActiveRecordTransition

  belongs_to :form_answer, optional: true, inverse_of: :form_answer_transitions

  def transitable
    t_type = metadata["transitable_type"]
    t_id = metadata["transitable_id"]
    if t_id.present? && t_type.present? && ["Admin", "Assessor", "User"].include?(t_type)
      t_type.constantize.find_by(id: t_id)
    end
  end
end
