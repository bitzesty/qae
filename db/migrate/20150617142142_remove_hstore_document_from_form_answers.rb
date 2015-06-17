class RemoveHstoreDocumentFromFormAnswers < ActiveRecord::Migration
  def change
    remove_column :form_answers, :hstore_document, :string
  end
end
