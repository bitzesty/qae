class AddAcceptedToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :accepted, :boolean, default: false
  end
end
