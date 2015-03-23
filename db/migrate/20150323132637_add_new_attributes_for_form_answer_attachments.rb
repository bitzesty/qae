class AddNewAttributesForFormAnswerAttachments < ActiveRecord::Migration
  def change
    add_column :form_answer_attachments, :title, :string
    add_column :form_answer_attachments, :restricted_to_admin, :boolean, default: false
  end
end
