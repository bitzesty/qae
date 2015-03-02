class CreateAssessmentRoles < ActiveRecord::Migration
  def change
    create_table :assessment_roles do |t|
      t.integer :assessor_id, null: false
      t.string :category, null: false
      t.string :role, null: false
      t.integer :year, null: false

      t.timestamps
    end

    add_index :assessment_roles,
              [:assessor_id, :category, :role, :year],
              unique: true,
              name: "assessment_roles_multiassignment_unique_index"
  end
end
