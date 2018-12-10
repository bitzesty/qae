class AddMostRecentToFormAnswerTransitions < ActiveRecord::Migration[4.2]
  def up
    add_column :form_answer_transitions, :most_recent, :boolean, null: true
  end

  def down
    remove_column :form_answer_transitions, :most_recent
  end
end
