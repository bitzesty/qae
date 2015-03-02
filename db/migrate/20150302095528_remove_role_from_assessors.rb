class RemoveRoleFromAssessors < ActiveRecord::Migration
  def change
    remove_column :assessors, :role, :string, null: false
  end
end
