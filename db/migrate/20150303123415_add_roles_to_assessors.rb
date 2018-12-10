class AddRolesToAssessors < ActiveRecord::Migration[4.2]
  def change
    add_column :assessors, :trade_role, :string
    add_column :assessors, :innovation_role, :string
    add_column :assessors, :development_role, :string
    add_column :assessors, :promotion_role, :string
  end
end
