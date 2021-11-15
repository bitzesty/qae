class DropListOfProcedures < ActiveRecord::Migration[6.1]
  def up
    drop_table :list_of_procedures
  end

  def down
    create_table :list_of_procedures do |t|
      t.references :form_answer, foreign_key: true
      t.string :attachment
      t.text :changes_description
      t.references :reviewable, polymorphic: true
      t.datetime :reviewed_at
      t.integer :status
      t.string :attachment_scan_results
      t.timestamps
    end
  end
end
