class RemoveRoleFromAdmins < ActiveRecord::Migration[4.2]
  def change
    remove_column :admins, :role, :string
  end
end
