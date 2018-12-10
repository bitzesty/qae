class AddRoleToAdmins < ActiveRecord::Migration[4.2]
  def change
    add_column :admins, :role, :string
  end
end
