class AddImportedToTheUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :imported, :boolean, default: false
  end
end
