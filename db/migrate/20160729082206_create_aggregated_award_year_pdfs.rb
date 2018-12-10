class CreateAggregatedAwardYearPdfs < ActiveRecord::Migration[4.2]
  def change
    create_table :aggregated_award_year_pdfs do |t|
      t.references :award_year, index: true, foreign_key: true
      t.string :award_category
      t.string :file

      t.timestamps null: false
    end
  end
end
