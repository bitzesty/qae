class AddDefaultValueToSubmittedField < ActiveRecord::Migration
  def up
    change_column :form_answers, :submitted, :boolean, default: false
  end

  def down
    change_column :form_answers, :submitted, :boolean
  end
end
