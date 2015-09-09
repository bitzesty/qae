class RemoveAddressCountryFromCompanyDetails < ActiveRecord::Migration
  def change
    remove_column :company_details, :address_country, :string
  end
end
