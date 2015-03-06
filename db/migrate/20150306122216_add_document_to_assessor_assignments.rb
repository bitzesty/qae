class AddDocumentToAssessorAssignments < ActiveRecord::Migration
  def change
    add_column :assessor_assignments, :document, :hstore
  end
end
