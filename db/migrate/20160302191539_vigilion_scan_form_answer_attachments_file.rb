class VigilionScanFormAnswerAttachmentsFile < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answer_attachments, :file_scan_results, :string
  end
end
