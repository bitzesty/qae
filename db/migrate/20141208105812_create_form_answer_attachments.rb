class CreateFormAnswerAttachments < ActiveRecord::Migration[4.2]
  def change
  create_table :form_answer_attachments do |t|
  t.integer 'form_answer_id'
      t.text 'file'
      t.text 'original_filename'
      t.text 'link'
      t.text 'description'
      t.timestamps
    end
  end
end
