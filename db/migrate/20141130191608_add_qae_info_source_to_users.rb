class AddQaeInfoSourceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :qae_info_source, :string
    add_column :users, :qae_info_source_other, :string
  end
end
