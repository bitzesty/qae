class AddAwardTypeToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :award_type, :string
  end
end
