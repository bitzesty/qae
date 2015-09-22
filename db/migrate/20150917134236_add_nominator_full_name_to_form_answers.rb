class AddNominatorFullNameToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :nominator_full_name, :string
  end
end
