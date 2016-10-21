class AddDeletedToAssessors < ActiveRecord::Migration
  def change
    add_column :assessors, :deleted, :boolean, default: :false
  end
end
