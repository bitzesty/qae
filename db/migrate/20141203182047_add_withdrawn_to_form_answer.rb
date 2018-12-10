class AddWithdrawnToFormAnswer < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :withdrawn, :boolean, default: false
  end
end
