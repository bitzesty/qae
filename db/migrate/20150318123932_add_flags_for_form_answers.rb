class AddFlagsForFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :admin_importance_flag, :boolean, default: false
    add_column :form_answers, :assessor_importance_flag, :boolean, default: false
  end
end
