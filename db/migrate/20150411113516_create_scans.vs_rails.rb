# This migration comes from vs_rails (originally 20150320102417)
class CreateScans < ActiveRecord::Migration[4.2]
  def change
    create_table :scans do |t|
      t.string  :uuid
      t.string  :filename
      t.string  :status

      t.timestamps
    end
  end
end
