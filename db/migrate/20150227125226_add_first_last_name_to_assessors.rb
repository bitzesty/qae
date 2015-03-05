class AddFirstLastNameToAssessors < ActiveRecord::Migration
  def change
    add_column :assessors, :first_name, :string
    add_column :assessors, :last_name, :string
  end
end
