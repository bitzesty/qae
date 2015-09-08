class MoveExtraFieldsToFormAnswers < ActiveRecord::Migration
  def change
    remove_column :company_details, :registration_number,              :string
    remove_column :company_details, :date_started_trading,             :string
    remove_column :company_details, :website_url,                      :string
    remove_column :company_details, :head_of_bussines_title,           :string
    remove_column :company_details, :head_of_business_full_name,       :string
    remove_column :company_details, :head_of_business_honours,         :string
    remove_column :company_details, :head_job_title,                   :string
    remove_column :company_details, :head_email,                       :string
    remove_column :company_details, :applying_for,                     :string
    remove_column :company_details, :parent_company,                   :string
    remove_column :company_details, :parent_company_country,           :string
    remove_column :company_details, :parent_ultimate_control,          :boolean
    remove_column :company_details, :ultimate_control_company,         :string
    remove_column :company_details, :ultimate_control_company_country, :string
    remove_column :company_details, :innovation_desc_short,            :string
    remove_column :company_details, :development_desc_short,           :string

    add_column :form_answers, :registration_number,              :string
    add_column :form_answers, :date_started_trading,             :string
    add_column :form_answers, :website_url,                      :string
    add_column :form_answers, :head_of_bussines_title,           :string
    add_column :form_answers, :head_of_business_full_name,       :string
    add_column :form_answers, :head_of_business_honours,         :string
    add_column :form_answers, :head_job_title,                   :string
    add_column :form_answers, :head_email,                       :string
    add_column :form_answers, :applying_for,                     :string
    add_column :form_answers, :parent_company,                   :string
    add_column :form_answers, :parent_company_country,           :string
    add_column :form_answers, :parent_ultimate_control,          :boolean
    add_column :form_answers, :ultimate_control_company,         :string
    add_column :form_answers, :ultimate_control_company_country, :string
    add_column :form_answers, :innovation_desc_short,            :string
    add_column :form_answers, :development_desc_short,           :string
  end
end
