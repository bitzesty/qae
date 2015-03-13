class AddSectionToTheComments < ActiveRecord::Migration
  def change
    add_column :comments, :section, :integer, index: true, null: false, default: 0
    change_column_default :comments, :section, nil
  end
end
