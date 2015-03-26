class ChangeFormAnswersStateDefaultValue < ActiveRecord::Migration
  def up
    change_column :form_answers, :state, :string, default: "application_in_progress", null: false
  end

  def down
    change_column :form_answers, :state, :string, default: "in_progress1", null: false
  end
end
