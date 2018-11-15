class RemoveHstoreDocumentFromFormAnswers < ActiveRecord::Migration[4.2]
  def change
    remove_column :form_answers, :hstore_document, :string
  end
end
