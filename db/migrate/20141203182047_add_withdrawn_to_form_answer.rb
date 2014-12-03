class AddWithdrawnToFormAnswer < ActiveRecord::Migration
  def change
    add_column :form_answers, :withdrawn, :boolean, default: false
  end
end
