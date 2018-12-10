class ChangeDefaultFormAnswerStateToEligibilityInProgress < ActiveRecord::Migration[4.2]
  def change
    change_column_default(:form_answers, :state, 'eligibility_in_progress')
  end
end
