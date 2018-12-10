class CreateFormAnswerProgresses < ActiveRecord::Migration[4.2]
  def change
    create_table :form_answer_progresses do |t|
      t.hstore :sections
      t.integer :form_answer_id, null: false
    end

    add_index :form_answer_progresses, :form_answer_id, unique: true
  end
end
