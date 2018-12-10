class AddUserEmailToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :user_email, :string
  end
end
