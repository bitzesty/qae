class AddAccountIdAndRoleToUsers < ActiveRecord::Migration[4.2]
  def change
    add_reference :users, :account, index: true
    add_column :users, :role, :string
  end
end
