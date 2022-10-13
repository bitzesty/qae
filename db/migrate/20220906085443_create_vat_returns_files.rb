class CreateVatReturnsFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :vat_returns_files do |t|
      t.string :attachment
      t.string :attachment_scan_results
      t.references :form_answer
      t.references :shortlisted_documents_wrapper

      t.timestamps
    end
  end
end
