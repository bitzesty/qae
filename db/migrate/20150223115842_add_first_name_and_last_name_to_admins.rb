class AddFirstNameAndLastNameToAdmins < ActiveRecord::Migration[4.2]
  def change
    add_column :admins, :first_name, :string
    add_column :admins, :last_name, :string
  end
end
