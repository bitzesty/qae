class RemoveNotNullConstraintFromAssessorAssignments < ActiveRecord::Migration
  def change
    change_column :assessor_assignments, :assessor_id, :integer, null: true
  end
end
