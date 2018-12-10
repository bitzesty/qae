class AddNominatorFullNameToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :nominator_full_name, :string
  end
end
