class RemoveImportanceFlagFromFormAnswers < ActiveRecord::Migration[4.2]
  def change
    remove_column :form_answers, :importance_flag, :boolean, default: false
  end
end
