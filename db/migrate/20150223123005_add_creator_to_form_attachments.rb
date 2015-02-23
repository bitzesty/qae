class AddCreatorToFormAttachments < ActiveRecord::Migration
  def change
    add_column :form_answer_attachments, :attachable_id, :integer, index: true
    add_column :form_answer_attachments, :attachable_type, :string
  end
end
