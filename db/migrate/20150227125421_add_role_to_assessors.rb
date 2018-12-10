class AddRoleToAssessors < ActiveRecord::Migration[4.2]
  def change
    add_column :assessors, :role, :string, null: false
  end
end
