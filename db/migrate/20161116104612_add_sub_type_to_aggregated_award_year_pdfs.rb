class AddSubTypeToAggregatedAwardYearPdfs < ActiveRecord::Migration[4.2]
  def change
    add_column :aggregated_award_year_pdfs, :sub_type, :string
  end
end
