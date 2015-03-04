class AddUserIdToSupporters < ActiveRecord::Migration
  def change
    add_reference :supporters, :user, index: true
    add_foreign_key :supporters, :users
  end
end
