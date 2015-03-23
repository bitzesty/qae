class CreateDraftNotes < ActiveRecord::Migration
  def change
    create_table :draft_notes do |t|
      t.text :content
      t.string :notable_type, null: false
      t.integer :notable_id, null: false

      t.string :authorable_type, null: false
      t.integer :authorable_id, null: false
      t.datetime :content_updated_at, null: false

      t.timestamps
    end
  end
end
