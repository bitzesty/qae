class CreatePressSummaries < ActiveRecord::Migration[4.2]
  def change
    create_table :press_summaries do |t|
      t.references :form_answer, index: true, null: false
      t.text :body
      t.text :comment
      t.boolean :approved, default: false

      t.timestamps null: false
    end
    add_foreign_key :press_summaries, :form_answers
  end
end
