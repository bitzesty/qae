class FormAnswerProgress < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :fill_progress, :float
  end
end
