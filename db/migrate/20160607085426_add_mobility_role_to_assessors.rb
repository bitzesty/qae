class AddMobilityRoleToAssessors < ActiveRecord::Migration[4.2]
  def change
    add_column :assessors, :mobility_role, :string
  end
end
