class RemoveCompanyDetails < ActiveRecord::Migration
  def change
    drop_table :company_details
  end
end
