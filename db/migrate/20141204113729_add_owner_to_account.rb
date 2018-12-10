class AddOwnerToAccount < ActiveRecord::Migration[4.2]
  def change
    add_reference :accounts, :owner, index: true
  end
end
