class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.references :form_answer, index: true
      t.boolean :submitted, default: false
      t.boolean :approved, default: false
      t.hstore :document

      t.timestamps null: false
    end
    add_foreign_key :feedbacks, :form_answers
  end
end
