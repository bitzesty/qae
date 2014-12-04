class AddAccountIdToFormAnswers < ActiveRecord::Migration
  def change
    add_reference :form_answers, :account, index: true
  end
end
