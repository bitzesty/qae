class AddSubmittedAtToAssessorAssignments < ActiveRecord::Migration[4.2]
  def change
    add_column :assessor_assignments, :submitted_at, :datetime
  end
end
