class AddAgreeBeingContactedByDepartmentOfBusinessToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :agree_being_contacted_by_department_of_business, :boolean, default: false
  end
end
