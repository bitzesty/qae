class CreateCaseSummaryHardCopyPdfs < ActiveRecord::Migration
  def change
    create_table :case_summary_hard_copy_pdfs do |t|
      t.references :form_answer, index: true, foreign_key: true
      t.string :file

      t.timestamps null: false
    end
  end
end
