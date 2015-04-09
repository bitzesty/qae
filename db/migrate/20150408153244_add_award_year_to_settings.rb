class AddAwardYearToSettings < ActiveRecord::Migration
  def up
    remove_column :settings, :year
    add_column :settings, :award_year_id, :integer, null: false
  end

  def down
    add_column :settings, :year, :integer
    remove_column :settings, :award_year_id
  end
end
