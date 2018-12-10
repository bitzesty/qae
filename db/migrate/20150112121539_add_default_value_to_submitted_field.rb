class AddDefaultValueToSubmittedField < ActiveRecord::Migration[4.2]
  def up
    change_column :form_answers, :submitted, :boolean, default: false
  end

  def down
    change_column :form_answers, :submitted, :boolean
  end
end
