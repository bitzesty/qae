class ChangeScans < ActiveRecord::Migration[4.2]
  def change
    change_column :scans, :uuid, :string, null: false
    add_index :scans, :uuid, unique: true
  end
end
