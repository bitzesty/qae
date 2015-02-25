class RenameTheCurrentAwardYear < ActiveRecord::Migration
  def change
    rename_column :form_answers, :current_award_year, :award_year
  end
end
