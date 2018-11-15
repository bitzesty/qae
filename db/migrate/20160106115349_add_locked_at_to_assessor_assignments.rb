class AddLockedAtToAssessorAssignments < ActiveRecord::Migration[4.2]
  def change
    add_column :assessor_assignments, :locked_at, :datetime
  end
end
