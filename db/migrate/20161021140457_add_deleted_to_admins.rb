class AddDeletedToAdmins < ActiveRecord::Migration[4.2]
  def change
    add_column :admins, :deleted, :boolean, default: false
  end
end
