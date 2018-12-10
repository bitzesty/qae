class RemoveAddressCountryFromCompanyDetails < ActiveRecord::Migration[4.2]
  def change
    remove_column :company_details, :address_country, :string
  end
end
