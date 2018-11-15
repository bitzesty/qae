class AddSubmittedAtToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :submitted_at, :datetime
  end
end
