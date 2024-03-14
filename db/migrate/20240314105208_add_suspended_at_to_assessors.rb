class AddSuspendedAtToAssessors < ActiveRecord::Migration[7.0]
  def change
    add_column :assessors, :suspended_at, :datetime
  end
end
