class ChangeTypeInAggregatedAwardYearPdfs < ActiveRecord::Migration[4.2]
  def change
    rename_column :aggregated_award_year_pdfs, :type, :type_of_report
  end
end
