class FixFormAttachments < ActiveRecord::Migration[4.2]
  def change
    add_index :form_answer_attachments, :form_answer_id
    remove_column :form_answer_attachments, :description
    remove_column :form_answer_attachments, :link
  end
end
