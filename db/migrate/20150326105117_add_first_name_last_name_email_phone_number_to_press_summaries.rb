class AddFirstNameLastNameEmailPhoneNumberToPressSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :press_summaries, :first_name, :string
    add_column :press_summaries, :last_name, :string
    add_column :press_summaries, :email, :string
    add_column :press_summaries, :phone_number, :string
    add_column :press_summaries, :correct, :boolean, default: false
    add_column :press_summaries, :reviewed_by_user, :boolean, default: false
  end
end
