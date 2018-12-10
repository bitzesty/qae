class AddCompanyToAssessors < ActiveRecord::Migration[4.2]
  def change
    add_column :assessors, :company, :string
  end
end
