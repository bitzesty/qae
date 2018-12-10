class AddStateToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :state, :string, null: false, default: 'in_progress'
  end
end
