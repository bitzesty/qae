class AddVsIdToScans < ActiveRecord::Migration
  def change
    add_column :scans, :vs_id, :string
  end
end
