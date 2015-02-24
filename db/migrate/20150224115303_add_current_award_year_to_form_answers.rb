class AddCurrentAwardYearToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :current_award_year, :integer, default: 2014, null: false
  end
end
