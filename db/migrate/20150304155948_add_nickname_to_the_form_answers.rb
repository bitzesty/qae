class AddNicknameToTheFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :nickname, :string
  end
end
