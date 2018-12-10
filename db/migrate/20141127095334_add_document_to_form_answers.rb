class AddDocumentToFormAnswers < ActiveRecord::Migration[4.2]
  def up
    add_column :form_answers, :document, :hstore
  end

  def down
    remove_column :form_answers, :document
  end
end
