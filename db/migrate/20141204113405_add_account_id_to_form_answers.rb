class AddAccountIdToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_reference :form_answers, :account, index: true
  end
end
