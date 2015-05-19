class AddQuestionKeyToTheFormAnswerAttachments < ActiveRecord::Migration
  def change
    add_column :form_answer_attachments, :question_key, :string
  end
end
