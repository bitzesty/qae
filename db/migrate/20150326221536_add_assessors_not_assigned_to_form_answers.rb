class AddAssessorsNotAssignedToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :primary_assessor_not_assigned, :boolean, default: true
    add_column :form_answers, :secondary_assessor_not_assigned, :boolean, default: true
  end
end
