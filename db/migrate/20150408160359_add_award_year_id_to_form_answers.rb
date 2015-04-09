class AddAwardYearIdToFormAnswers < ActiveRecord::Migration
  def up
    add_column :form_answers, :award_year_id, :integer, null: false
    add_index :form_answers, :award_year_id
    remove_column :form_answers, :award_year
  end

  def down
    remove_column :form_answers, :award_year_id, :integer, null: false
    remove_index :form_answers, :award_year_id
    add_column :form_answers, :award_year, :integer
  end
end
