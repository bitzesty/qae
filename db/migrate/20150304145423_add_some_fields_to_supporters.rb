class AddSomeFieldsToSupporters < ActiveRecord::Migration
  def change
    add_column :supporters, :first_name, :string
    add_column :supporters, :last_name, :string
    add_column :supporters, :relationship_to_nominee, :string
  end
end
