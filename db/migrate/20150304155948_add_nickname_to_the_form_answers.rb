class AddNicknameToTheFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :nickname, :string
  end
end
