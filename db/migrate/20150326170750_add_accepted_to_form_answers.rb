class AddAcceptedToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :accepted, :boolean, default: false
  end
end
