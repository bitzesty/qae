class CreateAwardYears < ActiveRecord::Migration
  def change
    create_table :award_years do |t|
      t.integer :year, null: false

      t.timestamps null: false
    end
  end
end
