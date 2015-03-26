class RemoveWithdrawnFromFormAnswers < ActiveRecord::Migration
  def change
    remove_column :form_answers, :withdrawn, :boolean
  end
end
