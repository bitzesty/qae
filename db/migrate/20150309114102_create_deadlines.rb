class CreateDeadlines < ActiveRecord::Migration
  def change
    create_table :deadlines do |t|
      t.string :kind
      t.datetime :trigger_at
      t.integer :settings_id

      t.timestamps null: false
    end

    add_index :deadlines, :settings_id
  end
end
