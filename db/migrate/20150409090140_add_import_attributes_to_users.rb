class AddImportAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address_line1, :string
    add_column :users, :address_line2, :string
    add_column :users, :address_line3, :string
    add_column :users, :postcode, :string
    add_column :users, :phone_number2, :string
    add_column :users, :mobile_number, :string
  end
end
