class AddCompletedRegistrationToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :completed_registration, :boolean, default: false
  end
end
