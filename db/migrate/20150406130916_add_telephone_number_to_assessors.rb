class AddTelephoneNumberToAssessors < ActiveRecord::Migration
  def change
    add_column :assessors, :telephone_number, :string
  end
end
