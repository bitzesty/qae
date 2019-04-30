class AddSessionLimitableToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :unique_session_id, :string
    add_column :assessors, :unique_session_id, :string
    add_column :users, :unique_session_id, :string
  end
end
