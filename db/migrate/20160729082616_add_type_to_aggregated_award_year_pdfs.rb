class AddTypeToAggregatedAwardYearPdfs < ActiveRecord::Migration
  def change
    add_column :aggregated_award_year_pdfs, :type, :string
  end
end
