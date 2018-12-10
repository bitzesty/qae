class AddUniqIndexToAwardYears < ActiveRecord::Migration[4.2]
  def up
    add_index :award_years, :year, unique: true
    remove_index :settings, :award_year_id
    add_index :settings, :award_year_id, unique: true
  end

  def down
    remove_index :award_years, :year
    remove_index :settings, :award_year_id
    add_index :settings, :award_year_id, unique: false
  end
end
