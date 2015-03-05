class CreateSupportLetterAttachments < ActiveRecord::Migration
  def change
    create_table :support_letter_attachments do |t|
      t.references :user, null: false, index: true
      t.references :form_answer, null: false, index: true
      t.string :attachment
      t.string :original_filename

      t.timestamps null: false
    end
    add_foreign_key :support_letter_attachments, :users
    add_foreign_key :support_letter_attachments, :form_answers
  end
end
