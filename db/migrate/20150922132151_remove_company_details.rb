class RemoveCompanyDetails < ActiveRecord::Migration[4.2]
  def change
    drop_table :company_details
  end
end
