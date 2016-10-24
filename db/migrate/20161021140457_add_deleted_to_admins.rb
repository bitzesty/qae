class AddDeletedToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :deleted, :boolean, default: false
  end
end
