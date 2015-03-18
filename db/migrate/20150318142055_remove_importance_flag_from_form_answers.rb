class RemoveImportanceFlagFromFormAnswers < ActiveRecord::Migration
  def change
    remove_column :form_answers, :importance_flag, :boolean, default: false
  end
end
