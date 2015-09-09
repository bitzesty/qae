class AddNominationAddressFieldsToCompanyDetails < ActiveRecord::Migration
  def change
    add_column :company_details, :nominee_organisation,         :string
    add_column :company_details, :nominee_position,             :string
    add_column :company_details, :nominee_organisation_website, :string
    add_column :company_details, :nominee_building,             :string
    add_column :company_details, :nominee_street,               :string
    add_column :company_details, :nominee_city,                 :string
    add_column :company_details, :nominee_county,               :string
    add_column :company_details, :nominee_postcode,             :string
    add_column :company_details, :nominee_telephone,            :string
    add_column :company_details, :nominee_email,                :string
    add_column :company_details, :nominee_region,               :string
    add_column :company_details, :nominator_name,               :string
    add_column :company_details, :nominator_building,           :string
    add_column :company_details, :nominator_street,             :string
    add_column :company_details, :nominator_city,               :string
    add_column :company_details, :nominator_county,             :string
    add_column :company_details, :nominator_postcode,           :string
    add_column :company_details, :nominator_telephone,          :string
    add_column :company_details, :nominator_email,              :string
  end
end
