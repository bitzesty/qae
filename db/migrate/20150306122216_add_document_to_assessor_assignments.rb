class AddDocumentToAssessorAssignments < ActiveRecord::Migration[4.2]
  def change
    add_column :assessor_assignments, :document, :hstore
  end
end
