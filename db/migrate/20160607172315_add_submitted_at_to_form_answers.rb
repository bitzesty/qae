class AddSubmittedAtToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :submitted_at, :datetime
  end
end
