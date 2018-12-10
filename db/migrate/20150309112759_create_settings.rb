class CreateSettings < ActiveRecord::Migration[4.2]
  def change
    create_table :settings do |t|
      t.integer :year

      t.timestamps null: false
    end
  end
end
