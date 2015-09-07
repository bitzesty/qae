class AddAddressCountyToCompanyDetails < ActiveRecord::Migration
  def change
    add_column :company_details, :address_county, :string
  end
end
