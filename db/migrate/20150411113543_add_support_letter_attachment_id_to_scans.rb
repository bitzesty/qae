class AddSupportLetterAttachmentIdToScans < ActiveRecord::Migration[4.2]
  def change
    add_column :scans, :support_letter_attachment_id, :integer
  end
end
