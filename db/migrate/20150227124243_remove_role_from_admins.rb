class RemoveRoleFromAdmins < ActiveRecord::Migration
  def change
    remove_column :admins, :role, :string
  end
end
