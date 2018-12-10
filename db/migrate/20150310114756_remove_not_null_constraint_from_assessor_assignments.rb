class RemoveNotNullConstraintFromAssessorAssignments < ActiveRecord::Migration[4.2]
  def change
    change_column :assessor_assignments, :assessor_id, :integer, null: true
  end
end
