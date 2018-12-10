class AddOriginalFilenameToCaseSummaryHardCopyPdfs < ActiveRecord::Migration[4.2]
  def change
    add_column :case_summary_hard_copy_pdfs, :original_filename, :string
  end
end
