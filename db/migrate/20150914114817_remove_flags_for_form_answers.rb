class RemoveFlagsForFormAnswers < ActiveRecord::Migration
  def change
    remove_column :form_answers, :admin_importance_flag, :boolean
    remove_column :form_answers, :assessor_importance_flag, :boolean
  end
end
