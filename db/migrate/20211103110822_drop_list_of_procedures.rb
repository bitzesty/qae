class DropListOfProcedures < ActiveRecord::Migration[6.1]
  def change
    drop_table :list_of_procedures
  end
end
