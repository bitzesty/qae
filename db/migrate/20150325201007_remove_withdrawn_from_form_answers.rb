class RemoveWithdrawnFromFormAnswers < ActiveRecord::Migration[4.2]
  def change
    remove_column :form_answers, :withdrawn, :boolean
  end
end
