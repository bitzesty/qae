class AddNominatorEmailToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :nominator_email, :string
  end
end
