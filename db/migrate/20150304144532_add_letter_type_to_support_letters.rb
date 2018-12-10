class AddLetterTypeToSupportLetters < ActiveRecord::Migration[4.2]
  def change
    add_column :support_letters, :manual, :boolean, default: false
  end
end
