class AddAwardTypeToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :award_type, :string
  end
end
