class RemoveRoleFromAssessors < ActiveRecord::Migration[4.2]
  def change
    remove_column :assessors, :role, :string
  end
end
