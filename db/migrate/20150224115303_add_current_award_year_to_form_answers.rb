class AddCurrentAwardYearToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :current_award_year, :integer, default: 2014, null: false
  end
end
