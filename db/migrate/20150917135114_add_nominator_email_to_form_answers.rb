class AddNominatorEmailToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :nominator_email, :string
  end
end
