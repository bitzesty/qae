class CreateFormAnswerAttachments < ActiveRecord::Migration
  def change
    create_table :form_answer_attachments do |t|
      t.integer 'form_id'
      t.string 'file'
      t.string 'link'
      t.string 'description'
      t.timestamps
    end
  end
end
