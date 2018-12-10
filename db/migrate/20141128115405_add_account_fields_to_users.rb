class AddAccountFieldsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :title, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    add_column :users, :job_title, :string
    add_column :users, :phone_number, :string

    add_column :users, :company_name, :string
    add_column :users, :company_address_first, :string
    add_column :users, :company_address_second, :string
    add_column :users, :company_city, :string
    add_column :users, :company_country, :string
    add_column :users, :company_postcode, :string
    add_column :users, :company_phone_number, :string

    add_column :users, :prefered_method_of_contact, :string
    add_column :users, :subscribed_to_emails, :boolean, default: false
  end
end
