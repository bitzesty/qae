class AddTelephoneNumberToAssessors < ActiveRecord::Migration[4.2]
  def change
    add_column :assessors, :telephone_number, :string
  end
end
