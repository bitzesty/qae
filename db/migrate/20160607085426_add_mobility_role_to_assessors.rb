class AddMobilityRoleToAssessors < ActiveRecord::Migration
  def change
    add_column :assessors, :mobility_role, :string
  end
end
