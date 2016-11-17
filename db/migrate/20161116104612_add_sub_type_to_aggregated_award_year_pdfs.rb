class AddSubTypeToAggregatedAwardYearPdfs < ActiveRecord::Migration
  def change
    add_column :aggregated_award_year_pdfs, :sub_type, :string
  end
end
