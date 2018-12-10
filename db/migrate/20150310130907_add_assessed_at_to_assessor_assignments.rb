class AddAssessedAtToAssessorAssignments < ActiveRecord::Migration[4.2]
  def change
    add_column :assessor_assignments, :assessed_at, :datetime
  end
end
