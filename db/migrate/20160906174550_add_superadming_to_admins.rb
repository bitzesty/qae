class AddSuperadmingToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :superadmin, :boolean, default: false
  end
end
