class ChangeTypeInAggregatedAwardYearPdfs < ActiveRecord::Migration
  def change
    rename_column :aggregated_award_year_pdfs, :type, :type_of_report
  end
end
