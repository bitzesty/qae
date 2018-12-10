class AddSuperadmingToAdmins < ActiveRecord::Migration[4.2]
  def change
    add_column :admins, :superadmin, :boolean, default: false
  end
end
