class AddImportanceFlagToTheFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :importance_flag, :boolean, default: false
  end
end
