class FormAnswerProgress < ActiveRecord::Migration
  def change
    add_column :form_answers, :fill_progress, :float
  end
end
