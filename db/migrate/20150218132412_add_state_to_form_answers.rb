class AddStateToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :state, :string, null: false, default: 'in_progress'
  end
end
