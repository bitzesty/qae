class CreateComments < ActiveRecord::Migration[4.2]
  def change
    create_table :comments do |t|
      t.integer :commentable_id, null: false, index: true
      t.string :commentable_type, null: false, index: true

      t.integer :author_id, null: false, index: true

      t.text :body, null: false
      t.timestamps
    end
  end
end
