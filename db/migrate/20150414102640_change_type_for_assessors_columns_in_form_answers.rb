class ChangeTypeForAssessorsColumnsInFormAnswers < ActiveRecord::Migration
  def change
    remove_column :form_answers, :primary_assessor_not_assigned, :boolean, default: true
    remove_column :form_answers, :secondary_assessor_not_assigned, :boolean, default: true

    add_column :form_answers, :primary_assessor_id, :integer, index: true
    add_column :form_answers, :secondary_assessor_id, :integer, index: true
  end
end
