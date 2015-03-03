class DropAssessmentRoles < ActiveRecord::Migration
  def change
    drop_table :assessment_roles do
    end
  end
end
