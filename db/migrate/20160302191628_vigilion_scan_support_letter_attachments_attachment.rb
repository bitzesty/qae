class VigilionScanSupportLetterAttachmentsAttachment < ActiveRecord::Migration[4.2]
  def change
    add_column :support_letter_attachments, :attachment_scan_results, :string
  end
end
