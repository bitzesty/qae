class AddLetterTypeToSupportLetters < ActiveRecord::Migration
  def change
    add_column :support_letters, :manual, :boolean, default: false
  end
end
