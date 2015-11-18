class FormAnswerTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  POSSIBLE_STATES_BEFORE_SHORTLISED_STAGE = [
    "assessment_in_progress",
    "submitted",
    "not_submitted",
    "application_in_progress",
    "reserved",
    "recommended"
  ]

  belongs_to :form_answer, inverse_of: :form_answer_transitions

  def transitable
    t_type = metadata["transitable_type"]
    t_id = metadata["transitable_id"]
    if t_id.present? && t_type.present? && ["Admin", "Assessor", "User"].include?(t_type)
      t_type.constantize.find(t_id)
    end
  end
end
