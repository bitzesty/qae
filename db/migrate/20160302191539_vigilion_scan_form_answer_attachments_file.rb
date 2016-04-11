class VigilionScanFormAnswerAttachmentsFile < ActiveRecord::Migration
  def change
    add_column :form_answer_attachments, :file_scan_results, :string
  end
end