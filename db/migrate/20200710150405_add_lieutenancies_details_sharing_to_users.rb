class AddLieutenanciesDetailsSharingToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :agree_sharing_of_details_with_lieutenancies, :boolean
  end
end
