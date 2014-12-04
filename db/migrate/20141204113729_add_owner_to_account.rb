class AddOwnerToAccount < ActiveRecord::Migration
  def change
    add_reference :accounts, :owner, index: true
  end
end
