class AddOriginalFilenameToFeedbackHardCopyPdfs < ActiveRecord::Migration
  def change
    add_column :feedback_hard_copy_pdfs, :original_filename, :string
  end
end
