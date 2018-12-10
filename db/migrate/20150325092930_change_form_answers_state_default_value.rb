class ChangeFormAnswersStateDefaultValue < ActiveRecord::Migration[4.2]
  def up
    change_column :form_answers, :state, :string, default: "application_in_progress", null: false
  end

  def down
    change_column :form_answers, :state, :string, default: "in_progress1", null: false
  end
end
