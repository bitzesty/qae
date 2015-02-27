class AddRoleToAssessors < ActiveRecord::Migration
  def change
    add_column :assessors, :role, :string, null: false
  end
end
