class ChangeFormAnswerAwardYearDefaultValue < ActiveRecord::Migration[4.2]
  def up
    change_column :form_answers, :award_year, :integer, default: nil, null: true
  end

  def down
    change_column :form_answers, :award_year, :integer, default: 2014, null: false
  end
end
