class CreateFormAnswerTransitions < ActiveRecord::Migration[4.2]
  def change
    create_table :form_answer_transitions do |t|
      t.string :to_state, null: false
      t.text :metadata, default: "{}"
      t.integer :sort_key, null: false
      t.integer :form_answer_id, null: false
      t.timestamps
    end

    add_index :form_answer_transitions, :form_answer_id
    add_index :form_answer_transitions, [:sort_key, :form_answer_id], unique: true
  end
end
