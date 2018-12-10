class AddDeletedToAssessors < ActiveRecord::Migration[4.2]
  def change
    add_column :assessors, :deleted, :boolean, default: :false
  end
end
