class AddSupportLetterAttachmentIdToScans < ActiveRecord::Migration
  def change
    add_column :scans, :support_letter_attachment_id, :integer
  end
end
