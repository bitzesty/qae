class CreateCommercialFiguresFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :commercial_figures_files do |t|
      t.string :attachment
      t.string :attachment_scan_results
      t.references :form_answer
      t.references :shortlisted_documents_wrapper, index: { name: "commercial_figures_files_sdw_ibd" }

      t.timestamps
    end
  end
end
