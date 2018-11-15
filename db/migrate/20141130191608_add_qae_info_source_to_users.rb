class AddQaeInfoSourceToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :qae_info_source, :string
    add_column :users, :qae_info_source_other, :string
  end
end
