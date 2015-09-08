class AddExtraFieldsToCompanyDetails < ActiveRecord::Migration
  def change
    add_column :company_details, :registration_number,              :string
    add_column :company_details, :date_started_trading,             :string
    add_column :company_details, :website_url,                      :string
    add_column :company_details, :head_of_bussines_title,           :string
    add_column :company_details, :head_of_business_full_name,       :string
    add_column :company_details, :head_of_business_honours,         :string
    add_column :company_details, :head_job_title,                   :string
    add_column :company_details, :head_email,                       :string
    add_column :company_details, :applying_for,                     :string
    add_column :company_details, :parent_company,                   :string
    add_column :company_details, :parent_company_country,           :string
    add_column :company_details, :parent_ultimate_control,          :boolean
    add_column :company_details, :ultimate_control_company,         :string
    add_column :company_details, :ultimate_control_company_country, :string
    add_column :company_details, :innovation_desc_short,            :string
    add_column :company_details, :development_desc_short,           :string
  end
end
