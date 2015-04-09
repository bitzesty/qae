class AddImportedToTheUsers < ActiveRecord::Migration
  def change
    add_column :users, :imported, :boolean, default: false
  end
end
