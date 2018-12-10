class AddAddressCountyToCompanyDetails < ActiveRecord::Migration[4.2]
  def change
    add_column :company_details, :address_county, :string
  end
end
