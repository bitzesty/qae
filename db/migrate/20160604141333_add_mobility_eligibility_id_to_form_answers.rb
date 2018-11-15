class AddMobilityEligibilityIdToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :mobility_eligibility_id, :integer
  end
end
