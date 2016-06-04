class AddMobilityEligibilityIdToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :mobility_eligibility_id, :integer
  end
end
