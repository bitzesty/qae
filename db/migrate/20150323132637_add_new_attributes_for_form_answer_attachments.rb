class AddNewAttributesForFormAnswerAttachments < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answer_attachments, :title, :string
    add_column :form_answer_attachments, :restricted_to_admin, :boolean, default: false
  end
end
