class ChangeScans < ActiveRecord::Migration
  def change
    change_column :scans, :uuid, :string, null: false
    add_index :scans, :uuid, unique: true
  end
end
