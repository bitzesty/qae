class AddVsIdToScans < ActiveRecord::Migration[4.2]
  def change
    add_column :scans, :vs_id, :string
  end
end
