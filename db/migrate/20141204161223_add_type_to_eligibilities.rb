class AddTypeToEligibilities < ActiveRecord::Migration
  def change
    add_column :eligibilities, :type, :string
  end
end
