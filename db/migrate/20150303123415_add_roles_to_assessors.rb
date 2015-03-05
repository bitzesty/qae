class AddRolesToAssessors < ActiveRecord::Migration
  def change
    add_column :assessors, :trade_role, :string
    add_column :assessors, :innovation_role, :string
    add_column :assessors, :development_role, :string
    add_column :assessors, :promotion_role, :string
  end
end
