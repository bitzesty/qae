class AddFirstLastNameToAssessors < ActiveRecord::Migration[4.2]
  def change
    add_column :assessors, :first_name, :string
    add_column :assessors, :last_name, :string
  end
end
