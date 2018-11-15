class AddQuestionKeyToTheFormAnswerAttachments < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answer_attachments, :question_key, :string
  end
end
