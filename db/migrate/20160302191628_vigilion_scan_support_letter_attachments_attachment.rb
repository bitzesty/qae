class VigilionScanSupportLetterAttachmentsAttachment < ActiveRecord::Migration
  def change
    add_column :support_letter_attachments, :attachment_scan_results, :string
  end
end