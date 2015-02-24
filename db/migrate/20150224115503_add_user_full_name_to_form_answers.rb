class AddUserFullNameToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :nominee_full_name, :string, index: true
    add_column :form_answers, :user_full_name, :string, index: true
    add_column :form_answers, :award_type_full_name, :string, index: true
  end
end
