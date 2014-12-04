class AddAccountIdAndRoleToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :account, index: true
    add_column :users, :role, :string
  end
end
