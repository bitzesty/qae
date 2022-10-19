class CreateShortlistedDocumentsWrappers < ActiveRecord::Migration[6.1]
  def change
    create_table :shortlisted_documents_wrappers do |t|
      t.references :form_answer
      t.datetime :submitted_at

      t.timestamps
    end
  end
end
