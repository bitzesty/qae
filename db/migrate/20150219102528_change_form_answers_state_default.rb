class ChangeFormAnswersStateDefault < ActiveRecord::Migration
  def up
    change_column :form_answers, :state, :string, default: 'in_progress1', null: false
    execute("UPDATE form_answers SET state = 'in_progress1'")
  end

  def down
    change_column :form_answers, :state, :string, default: 'in_progress', null: false
  end
end
