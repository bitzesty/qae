class AddFormAnswerAttachmentItToScans < ActiveRecord::Migration[4.2]
  def change
    add_column :scans, :form_answer_attachment_id, :integer
  end
end
