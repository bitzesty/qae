class DropAssessmentRoles < ActiveRecord::Migration[4.2]
  def change
    drop_table :assessment_roles do
    end
  end
end
