class AddOriginalFilenameToAggregatedAwardYearPdfs < ActiveRecord::Migration
  def change
    add_column :aggregated_award_year_pdfs, :original_filename, :string
  end
end
