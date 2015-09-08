class AddCompanyToAssessors < ActiveRecord::Migration
  def change
    add_column :assessors, :company, :string
  end
end
