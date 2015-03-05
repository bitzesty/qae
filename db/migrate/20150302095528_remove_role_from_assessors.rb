class RemoveRoleFromAssessors < ActiveRecord::Migration
  def change
    remove_column :assessors, :role, :string
  end
end
