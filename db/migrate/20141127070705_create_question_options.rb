class CreateQuestionOptions < ActiveRecord::Migration
  def change
    create_table :question_options do |t|
      t.references :question, index: true
      t.text :title
      t.text :input
      t.boolean :with_input
      t.integer :placement

      t.timestamps
    end
  end
end
