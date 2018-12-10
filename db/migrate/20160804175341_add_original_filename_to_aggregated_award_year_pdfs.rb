class AddOriginalFilenameToAggregatedAwardYearPdfs < ActiveRecord::Migration[4.2]
  def change
    add_column :aggregated_award_year_pdfs, :original_filename, :string
  end
end
