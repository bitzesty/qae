class AddImportanceFlagToTheFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :importance_flag, :boolean, default: false
  end
end
