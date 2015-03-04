class AddSupportLetterIdToSupportLetterAttachments < ActiveRecord::Migration
  def change
    add_reference :support_letter_attachments, :support_letter, index: true
    add_foreign_key :support_letter_attachments, :support_letters
  end
end
