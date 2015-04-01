class CreatePreviousWins < ActiveRecord::Migration
  def change
    create_table :previous_wins do |t|
      t.integer :form_answer_id, null: false
      t.string :category
      t.integer :year
      t.timestamps
    end
  end
end
