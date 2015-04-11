class AddFormAnswerAttachmentItToScans < ActiveRecord::Migration
  def change
    add_column :scans, :form_answer_attachment_id, :integer
  end
end
