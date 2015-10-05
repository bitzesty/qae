class AddUserEmailToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :user_email, :string
  end
end
