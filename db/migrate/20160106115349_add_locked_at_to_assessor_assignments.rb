class AddLockedAtToAssessorAssignments < ActiveRecord::Migration
  def change
    add_column :assessor_assignments, :locked_at, :datetime
  end
end
